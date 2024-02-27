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




--main = toJSONFilter writeCustomCodeBlocks

main :: IO ()
main = do
    args <- getArgs
    file <- case args of 
        (p:ps)  -> pure p
        _       -> exitFailure

    -- setup application environment in IO
    appopts <- executingStateT def $ do

        appoptTemplatesDir <~ getTemplateCodeBlock "" 
        appoptLatex .= "xelatex"
        appoptInputFile .= unsafeEncodeUtf file
        appoptOutputFile .= unsafeEncodeUtf file) -<.> "pdf"
        appoppOutputFormat .= FileFormatPDF
        --appoptMaybeValue ?= 3044 -- Just 3044
       
    -- run our custom PandocMonad
    usingReaderT appopts $ do --res <- runIOorExplode $ do
        file <- use appoptInputFile
        ropts <- use appoptReaderOptions
        pandoc <- readMarkdown ropts =<< fmap decodeUtf8 $ readFileBS file
        meta <- yamlToMeta ropts (Just file) =<< readFileBS file

        -- reconfigure WriterOptions:
        --   * compile our custom output Template 
        --   * populate Context (variables)
        wopts <- zoom appoptWriterOptions $ do
            -- TODO: write variables: meta + command arguments

            -- TODO: read custom template
            tres <- fmap decodeUtf8 readFileBS $ compileTemplate "" 
            case tres of 
                Left err        -> throwError err
                Right template  -> writerTemplateL .= template

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
                latex <- use apptoptLatex
                latexopts <- use apptoptLatexOpts
                makePDF latex latexopts writeLatex wopts pandoc' 
            _               -> die "Output FileFormat not implemented"



-- | TODO: ignore "shellbox", look for templates in folder instead!
walkCodeBlocks :: (Block -> PandocApp Block) -> Pandoc -> PandocApp Pandoc
walkCodeBlocks block(CodeBlock atts@(id, cs, kvs) text) =
    --pathTemplatesCodeBlock >>= \ps -> 
    --    -- TODO list filenames
    --    case cs of 
    --        -- codeblock has a name, lets see if we have a template for it
    --        (c:cs)  -> 
    --        _       -> pure block

    case cs of 
        ("shellbox":cs) -> writeShellbox (id, cs, kvs) text
        _               -> pure block
walkCodeBlocks =
    pure 



-- why not using RawBlock? because ```{=name} is not allowed more attributes

-- use the codeblock syntax for custom latex (environments, typically)
writeCustomCodeBlocks :: Block -> PandocApp Block
writeCustomCodeBlocks block(CodeBlock atts@(id, cs, kvs) text) =
    case cs of 
        ("shellbox":cs) -> writeShellbox (id, cs, kvs) text
        _               -> pure block
writeCustomCodeBlocks =
    pure 


writeShellbox :: Atts -> Text -> PandocApp Block
writeShellbox (id, classes, keymap) = \text ->

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

    return $ RawBlock (Format "shellbox") text'


