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
import System.Directory
import System.FilePath




--main = toJSONFilter writeCustomCodeBlocks

main :: IO ()
main = do
    args <- getArgs
    file <- case args of 
        (p:ps)  -> pure p
        _       -> exitFailure

    -- setup application environment in IO
    appopts <- executingStateT def $ do

        appoptTemplatesDir <~ getData "templates/"
        appoptLatex .= "xelatex"
        appoptInputFile .= file
        appoptOutputFile .= file -<.> "pdf"
        appoppOutputFormat .= FileFormatPDF

        --appoptOutputFile <~ getUserDir 
        --appoptMaybeValue ?= 3044 -- Just 3044
       

    -- run our custom PandocMonad
    usingReaderT appopts $ do --res <- runIOorExplode $ do
        file <- use appoptInputFile
        ropts <- use appoptReaderOptions
        pandoc <- readMarkdown ropts =<< fmap decodeUtf8 $ readFileBS file
        meta <- yamlToMeta ropts (Just file) =<< readFileBS file

        -- reconfigure WriterOptions:
        --   * compile our custom output Template 
        --   * populate variables
        wopts <- zoom appoptWriterOptions $ do
            -- TODO: write variables: meta + command arguments

            -- TODO: read custom template
            writerTemplateL <~ compileTemplate
            res <- compileTemplate "" str :: Template Text
            renderTemplate (Template Text) (Context Text) :: Doc Text
            case compileTemplate "" str :: 

        -- filter pandoc document (this is where the magic happens)
        pandoc' <- walkM walkCodeBlocks pandoc 

        -- write
        use appoptOutputFormat >>= \fmt -> case fmt of
            FileFormatEmpty -> pass
            FileFormatPDF   -> do
                latex <- use apptoptLatex
                latexopts <- use apptoptLatexOpts
                --wopts <- use appoptWriterOptions -- Done above with new settings!
                makePDF latex latexopts writeLatex wopts pandoc' 
            _               -> die "Output FileFormat not implemented"



walkCodeBlocks :: (Block -> PandocApp Block) -> Pandoc -> PandocApp Pandoc
walkCodeBlocks block(CodeBlock atts@(id, cs, kvs) text) =
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
    getUserDataDir
    getResourcePath
    lookupEnv
    lookupMedia / MediaBag
    extractMedia 

    -- 0. read template file
    readFileFromDirs :: [FilePath] -> FilePath ->  (Maybe Text)
    -- 1. populate YAML variables using 'classes' and 'keymap'
    --    - either programatically after reading, or merge into Pandoc state
    template readFileText 
    -- 2. return new Block (RawBlock) based on this

    return $ RawBlock (Format "shellbox") text


