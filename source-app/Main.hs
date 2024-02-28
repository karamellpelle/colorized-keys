-- Copyright (C) 2024 karamellpelle@hotmail.com
-- 
-- This file is part of 'colorized-keys'.
-- 
-- 'colorized-keys' is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
-- 
-- 'colorized-keys' is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with 'colorized-keys'.  If not, see <http://www.gnu.org/licenses/>.
--
import Relude
import My

import Pandoc
import Text.Pandoc.Readers.Markdown
import Text.Pandoc.Writers.LaTeX
import Text.Pandoc.PDF
import Text.Pandoc.Walk
import System.OsPath as OsPath
import System.File.OsPath as OsPath
import AppOpts
import Data



--main = toJSONFilter writeCustomCodeBlocks

main :: IO ()
main = do

    -- setup our application environment inside IO
    appopts <- executingStateT def $ do

        -- retrieve first program argument as input OsPath
        args <- getArgs
        ospath <- case args of 
            (p:ps)  -> encodeUtf p
            _       -> exitFailure


        appoptTemplatesDir <~ pathTemplateCodeBlock ""
        appoptLatex        .= "xelatex"
        appoptInputFile    .= ospath
        appoptOutputFile   .= ospath -<.> mkOsPath "pdf"
        appoptOutputFormat .= FileFormatPDF
        --appoptMaybeValue ?= 3044 -- Just 3044
      

    -- run our custom PandocMonad
    -- FIXME: run PandocApp
    usingReaderT @AppOpts @PandocApp appopts $ do --res <- runIOorExplode $ do
        ospath <- use appoptInputFile
        ropts  <- use appoptReaderOptions
        pandoc <- readMarkdown ropts =<< (io $ OsPath.readFile' ospath)
        meta   <- yamlToMeta ropts Nothing =<< (io $ OsPath.readFile' ospath)

        -- reconfigure WriterOptions:
        --   * compile our custom output Template 
        --   * populate Context (variables)
        wopts <- zoom appoptWriterOptions $ do
            -- TODO: write variables: meta + command arguments

            -- TODO: read custom template
            tres <- io $ compileTemplate ""  =<< fmap (decodeUtf8 @Text @ByteString) (OsPath.readFile' ospath) -- ^ FIXME: partials file?
            case tres of 
                Left err        -> die err
                Right template  -> writerTemplateL ?= template


        -- TODO: lift values into PandocMonad:
        --    - setResourcePath
        --    - setOutputFile
        --    - setDataFile??
        --
        -- filter pandoc document (this is where the magic happens)
        pandoc' <- walkM walkCodeBlocks pandoc 

        -- write
        use appoptOutputFormat >>= \fmt -> case fmt of
            FileFormatEmpty -> pass
            FileFormatPDF   -> do
                latex <- use appoptLatex
                latexopts <- use appoptLatexOpts
                makePDF latex latexopts writeLaTeX wopts pandoc' >>= \case
                    Left log  -> do

                        writeFileLBS "error.log" log
                        die "Error encountered - see error.log"

                    Right pdf -> do 
                        view appoptOutputFile >>= \ospath -> do
                            io $ OsPath.writeFile ospath pdf
                            decodeUtf ospath >>= \path -> putTextLn $ "PDF written to :" <> toText path

            _                 -> die "Output FileFormat not implemented"

        pass


-- | TODO: ignore "shellbox", look for templates in folder instead!
walkCodeBlocks :: Block -> PandocApp Block 
walkCodeBlocks block@(CodeBlock atts@(id, cs, kvs) text) = do
    --pathTemplatesCodeBlock >>= \ps -> 
    --    -- TODO list filenames
    --    case cs of 
    --        -- codeblock has a name, lets see if we have a template for it
    --        (c:cs)  -> 
    --        _       -> pure block

    case cs of 
        ("shellbox":cs) -> writeCustomCodeBlocks block
        _               -> pure block
walkCodeBlocks block =
    pure block



-- why not using RawBlock? because ```{=name} is not allowed more attributes

-- use the codeblock syntax for custom latex (environments, typically)
writeCustomCodeBlocks :: Block -> PandocApp Block
writeCustomCodeBlocks block@(CodeBlock atts@(id, cs, kvs) text) =
    case cs of 
        ("shellbox":cs) -> do 
{-
            --readFileStrict :: FilePath -> PandocIO ByteString
            getDataFileName :: FilePath -> PandocIO m FilePath
            --lookupEnv "CODEBLOCKTEMPLATES_DIR"
            --getUserDataDir
            --getResourcePath

            -- 0. read template file
            readFileFromDirs :: [FilePath] -> FilePath ->  (Maybe Text)
            -- 1. populate YAML variables using 'classes' and 'keymap'
            --    - either programatically after reading, or merge into Pandoc state
            -- 2. return new Block (RawBlock) based on this
            template readFileText 
            text' <- render Nothing $ renderTemplate (Template Text) (Context Text) 
-}
            text' <- pure text
            return $ RawBlock (Format "shellbox") text'


        _               -> pure block

writeCustomCodeBlocks block =
    pure block
