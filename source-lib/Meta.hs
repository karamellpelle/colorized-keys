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
module Meta
(
    (.>),
    pickMeta,
    pickMeta',
    pickMetaValue,
    
    FromMetaValue (..),
) where

import Relude
import My

import Relude.Extra.Map
import Text.Pandoc.Definition


--------------------------------------------------------------------------------
--  

(.>) :: Maybe MetaValue -> Text -> Maybe MetaValue
(.>) mb str = 
    join $ fmap helper mb
    where 
      helper (MetaMap map) = map !? str
      helper _ =  Nothing


--------------------------------------------------------------------------------
--  

pickMeta :: FromMetaValue a => Meta -> [Text] -> Maybe a
pickMeta meta texts = fromMetaValue =<< foldl' (.>) (pure (MetaMap (unMeta meta))) texts

pickMeta' :: (Default a, FromMetaValue a) => Meta -> [Text] -> a 
pickMeta' meta texts = pickMeta meta texts ?: def

pickMetaValue :: Meta -> [Text] -> Maybe MetaValue
pickMetaValue meta texts = foldl' (.>) (pure (MetaMap (unMeta meta))) texts

--------------------------------------------------------------------------------
--  

class FromMetaValue a where
    fromMetaValue :: MetaValue -> Maybe a
