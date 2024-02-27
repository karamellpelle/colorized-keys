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
    AppOpts,
    appoptTemplatesDir,
    appoptInputFile,
    appoptOutputFile,
    appoptLatex,
    appoptLatexOpts,
    appoptWriterOptions,

    PandocApp,
    FileFormat,

) where 

import Relude
import My

import Lens.Micro.TH
import System.OsPath
import Text.Pandoc


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



--------------------------------------------------------------------------------
--  AppOpts

data AppOpts = AppOpts {
      _appoptTemplatesDir :: OsPath
    , _appoptInputFile :: OsPath
    , _appoptOutputFile :: OsPath
    , _appoptOutputFormat :: FileFormat
    , _appoptLatex :: String
    , _appoptLatexOpts :: [String]
    , _appoptReaderOptions :: ReaderOptions
    , _appoptWriterOptions :: WriterOptions
    
    }


instance Default AppOpts where
    def = AppOpts {
      _appoptTemplatesDir  = mkOsPath "."
    , _appoptInputFile     = mkOsPath ""
    , _appoptOutputFile    = mkOsPath ""
    , _appoptLatex         = "xelatex"
    , _appoptOutputFormat  = FileFormatEmpty
    , _appoptLatexOpts     = []
    , _appoptReaderOptions = readerOpts
    , _appoptWriterOptions = writerOpts
    }


mkOsPath :: String -> OsPath
mkOsPath str = System.OsPath.pack $ map unsafeFromChar str
-- ^ TODO: use unsafeEncodeUtf when newer filepath version is available in stack snapshot


--------------------------------------------------------------------------------
--  

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


