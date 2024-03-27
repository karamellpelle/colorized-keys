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
{-# OPTIONS_GHC -Wno-orphans #-}
module Replace
(
    Replace,
    ReplaceLanguage,
    metaReplace,

    -- tmp
    replace,
    replaceShellbox,
) where

import Relude
import My

import Relude.Extra.Map
import Text.Pandoc.Definition
import Meta


--------------------------------------------------------------------------------
--  Replace data

type Replace = Map Text ReplaceLanguage

type ReplaceLanguage = Map Char Text


metaReplace :: Meta -> Replace
metaReplace meta = pickMeta' meta $ ("colorized-keys" : "replace" : [])


instance FromMetaValue Char where
    fromMetaValue (MetaString str) =
        case toString str of
            [c] -> Just c
            _   -> Nothing
    fromMetaValue _ = Nothing

instance FromMetaValue Text where
    fromMetaValue (MetaInlines [Str str]) = Just str
    fromMetaValue _ = Nothing

instance FromMetaValue ReplaceLanguage where
    fromMetaValue (MetaMap mmap) =
        pure $ fromList $ mapMaybe (bitraverse maybeOneChar fromMetaValue) $ toPairs mmap
        where 
          maybeOneChar text = case toString text of
            [a] -> Just a
            _   -> Nothing
    fromMetaValue _ = Nothing

instance FromMetaValue Replace where
    fromMetaValue (MetaMap mmap) =
          pure $ fromList $ mapMaybe (bitraverse pure fromMetaValue) $ toPairs mmap
    fromMetaValue _ = Nothing
       

--------------------------------------------------------------------------------
--  tmp

replace :: Replace
replace = fromList [ ("shellbox", replaceShellbox),
                     ("sh", replaceShellbox),
                     ("default", replaceShellbox) ]

replaceShellbox :: ReplaceLanguage
replaceShellbox =
    fromList [
        ( '🔑', "KeyPrivateTok" )
      , ( '🔒', "KeyPublicTok" )
      , ( '🔐', "KeyPairTok" )
      , ( '❗', "IdentifierTok" )
    ]


