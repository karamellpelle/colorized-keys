-- Copyright (C) 2023 karamellpelle@hotmail.com
-- 
-- This file is part of 'subject'.
-- 
-- 'subject' is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
-- 
-- 'subject' is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with 'subject'.  If not, see <http://www.gnu.org/licenses/>.
--
{-# LANGUAGE TemplateHaskell #-}

module AppOpts (
    --AppOptions (..),
    AppOptions,
    appoptTemplatesDir,
    appoptInputFile,
    appoptOutputFile,
    appoptLatex,
    appoptLatexOpts,
    appoptWriterOptions,

    PandocApp (..),
    FileFormat,

    readerOpts,
    writerOpts,
) where 

import Relude
import My

import Lens.Micro.TH

data AppOpts = AppOpts {
      _appoptTemplatesDir :: FilePath
    , _appoptInputFile :: FilePath
    , _appoptOutputFile :: FilePath
    , _appoptOutputFormat :: FileFormat
    , _appoptLatex :: String
    , _appoptLatexOpts :: [String]
    , _appoptReaderOptions :: ReaderOptions
    , _appoptWriterOptions :: WriterOptions
    
    }


instance Default AppOpts where
    def = AppOptions {
      _appoptTemplatesDir  = "."
    , _appoptInputFile     = ""
    , _appoptOutputFile    = ""
    , _appoptLatex         = "xelatex"
    , _appoptOutputFormat  = FileFormatEmpty
    , _appoptLatexOpts     = []
    , _appoptWriterOptions = def
    }

data FileFormat =
    FileFormatEmpty    |
    FileFormatMarkdown |
    FileFormatLaTeX    |
    FileFormatPDF      |
    FileFormatHTML

makeLenses ''AppOpts

--------------------------------------------------------------------------------
--  PandocApp

-- | our application environment
type PandocApp = ReaderT AppOpts PandocIO


--------------------------------------------------------------------------------
--  our default read/write settings

readerOpts :: ReaderOptions
readerOpts = def { 
        readerExtensions = pandocExtensions <> mempty
    }

writerOpts :: WriterOptions
writerOpts = def {
        writerExtensions = pandocExtensions <> mempty
}


