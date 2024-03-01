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
{-# OPTIONS_GHC -Wno-unused-imports #-}
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




main :: IO ()
main = do

    -- setup our application configuration: AppOpts
    appopts <- executingStateT def $ do

        -- use first first program argument as input path
        args <- getArgs
        ospath <- case args of 
            (p:ps)  -> encodeUtf p
            _       -> die "Missing input file"

        appoptTemplatesDir <~ pathTemplateCodeBlock ""
        appoptLatex        .= "xelatex"
        appoptInputFile    .= ospath
        appoptOutputFile   .= ospath -<.> mkOsPath "pdf"
        appoptOutputFormat .= FileFormatPDF
      

    -- run our custom PandocApp (ReaderT AppOpts PandocIO)
    runIOorExplode $ usingReaderT appopts $ do --res <- runIOorExplode $ do

        ospath <- view appoptInputFile
        ropts  <- view appoptReaderOptions
        pandoc <- readMarkdown ropts =<< readFileOsPathText ospath 
        meta   <- yamlToMeta ropts Nothing =<< readFileOsPathByteString ospath 

        -- reconfigure WriterOptions
        wopts  <- view appoptWriterOptions 
        wopts' <- executingStateT wopts $ do
        --wopts' <- (view appoptWriterOptions >>= executingStateT) $ do -- FIXME: why doesn't this work?

            -- add our custom document template
            tres <- io $ compileTemplate ""  =<< readFileOsPathText ospath 
            case tres of 
                Left err        -> die err
                Right template  -> writerTemplateL ?= template


        -- TODO: lift values into our PandocMonad:
        --    - setResourcePath
        --    - setOutputFile
        --    - setDataFile??


        -- filter pandoc document (this is where the magic happens)
        pandoc' <- walkM walkCodeBlocks pandoc 


        -- write pandoc document to file
        view appoptOutputFormat >>= \fmt -> case fmt of
            FileFormatEmpty -> pass
            FileFormatPDF   -> do
                latex     <- view appoptLatex
                latexopts <- view appoptLatexOpts
                makePDF latex latexopts writeLaTeX wopts' pandoc' >>= \case
                    Left log  -> do

                        writeFileLBS "error.log" log
                        die "Error encountered - see error.log"

                    Right pdf -> do 
                        view appoptOutputFile >>= \ospath -> do
                            io $ OsPath.writeFile ospath pdf
                            decodeUtf ospath >>= \path -> putTextLn $ "PDF written to :" <> toText path

            _ -> die "Output FileFormat not implemented"

        pass


-- | TODO: ignore "shellbox", look for templates with matching name in folder 
walkCodeBlocks :: Block -> PandocApp Block 
walkCodeBlocks block@(CodeBlock atts@(id, cs, kvs) text) = do
    --pathTemplatesCodeBlock >>= \ps -> 
    --    -- TODO list filenames
    --    case cs of 
    --        -- codeblock has a name, lets see if we have a template for it
    --        (c:cs)  -> 
    --        _       -> pure block

    case cs of 
        ("shellbox":cs) -> writeCustomCodeBlocks "shellbox" block
        _               -> pure block

walkCodeBlocks block =
    pure block


-- map Block to RawBlock
writeCustomCodeBlocks :: Text -> Block -> PandocApp Block
writeCustomCodeBlocks format block@(CodeBlock atts@(id, cs, kvs) text) = do
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
      return $ RawBlock (Format format) text'


writeCustomCodeBlocks format block =
    pure block



--------------------------------------------------------------------------------
--  reading files from OsPath

readFileOsPathText :: MonadIO m => OsPath -> m Text
readFileOsPathText = \ospath ->
    io $ fmap (decodeUtf8 @Text @ByteString) (OsPath.readFile' ospath)

readFileOsPathByteString :: MonadIO m => OsPath -> m ByteString
readFileOsPathByteString = \ospath ->
    io $ OsPath.readFile' ospath
