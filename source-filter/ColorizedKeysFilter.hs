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
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE DeriveGeneric #-}
module ColorizedKeysFilter
(
    ColorizedKeysFilter,
    ColorizedApp,
    colorizedVersion, 
    colorizedPandoc, 
    colorizedReplace, 
    colorizedDataDir,

) where

import Relude
import My

import Lens.Micro.TH
import System.FilePath
import Text.Pandoc
import Replace
import Data.Yaml
import Data.Version
import GHC.Generics hiding (UInt, Meta)


data ColorizedKeysFilter = ColorizedKeysFilter {
      _colorizedVersion :: Version
    , _colorizedPandoc  :: Pandoc
    , _colorizedReplace :: Replace
    , _colorizedDataDir :: FilePath

    } deriving (Generic)


instance Default ColorizedKeysFilter where
    def = ColorizedKeysFilter {
          _colorizedVersion = makeVersion [0, 0]
        , _colorizedPandoc = Pandoc nullMeta def
        , _colorizedReplace = def
        , _colorizedDataDir = def

        }


type ColorizedApp = ReaderT ColorizedKeysFilter IO

instance ToJSON ColorizedKeysFilter

instance FromJSON ColorizedKeysFilter

makeLenses ''ColorizedKeysFilter
