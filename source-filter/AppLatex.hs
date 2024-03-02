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
{-# OPTIONS_GHC -Wno-unused-imports #-}
module AppLatex
(
    AppDataLatex,
    AppLatex,
    main,

) where

import Relude
import My

import Lens.Micro.TH
import System.OsPath
import Text.Pandoc
import Text.Pandoc.Walk()
import App



data AppDataLatex = AppDataLatex {
      _appVersion :: UInt
  
  }

makeLenses ''AppDataLatex


instance Default AppDataLatex where
    def = AppDataLatex {
        _appVersion = 0
    }


type AppLatex = AppM AppDataLatex


--------------------------------------------------------------------------------
--  

main :: Block -> AppLatex Block
main = \block -> case block of
    (CodeBlock atts@(id, cs, kvs) text) -> case cs of
        (language:cs)  -> do
            --return $ RawBlock (Format language) text'
            pure $ CodeBlock atts $ text <> "\n\n^^^ " <> show atts

        _ -> pure block
    _ -> pure block
    

