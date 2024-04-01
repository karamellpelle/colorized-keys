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
module Languages
(
    Languages,
    Language(..),
    EmojiMap,
    metaColorizedLanguages,

    ---- tmp
    --replace,
    --replaceShellbox,
) where

import Relude
import My

import Relude.Extra.Map
import Relude.Extra.Tuple
import Text.Pandoc.Definition
import Meta


--------------------------------------------------------------------------------
--  Languages data

type Languages = Map Text Language

data Language = Language { 
    languageSyntax   :: String
  , languageStyle    :: String
  , languageEmojiMap :: EmojiMap
  } deriving (Show)

type EmojiMap = Map Char Text


--------------------------------------------------------------------------------
--  

metaColorizedLanguages :: Meta -> Languages
metaColorizedLanguages meta = pickMeta' meta $ ("colorized-keys" : "languages" : [])

instance FromMetaValue Char where
    fromMetaValue (MetaString str) =
        case toString str of
            [c] -> Just c
            _   -> Nothing
    fromMetaValue _ = Nothing

--instance IsString a => FromMetaValue a where doenst work!!!
instance FromMetaValue Text where
    fromMetaValue (MetaInlines [Str str]) = Just str
    fromMetaValue _ = Nothing

instance FromMetaValue String where
    fromMetaValue (MetaInlines [Str str]) = Just $ toString str
    fromMetaValue _ = Nothing

instance FromMetaValue EmojiMap where
    fromMetaValue (MetaMap mmap) =
        pure $ fromList $ mapMaybe (bitraverse maybeOneChar fromMetaValue) $ toPairs mmap
        where 
          maybeOneChar text = case toString text of
            [a] -> Just a
            _   -> Nothing
    fromMetaValue _ = Nothing

instance FromMetaValue Language where
    fromMetaValue mv = do
        style <- maybeStyle mv 
        syntax <- maybeSyntax mv 
        emoji <- maybeEmoji mv
        pure $ Language style syntax emoji
      where
        maybeStyle mv = pure mv .> "style" >>= fromMetaValue
        maybeSyntax mv = pure mv .> "syntax" >>= fromMetaValue
        maybeEmoji mv = pure mv .> "map" >>= fromMetaValue

--------------------------------------------------------------------------------
--  tmp
{-
replace :: Languages
replace = 
    fromList $ fmap (second (Language "" "")) [ 
               ("shellbox", replaceShellbox)
             , ("sh", replaceShellbox)
             , ("default", replaceShellbox) 
             ]


replaceShellbox :: EmojiMap
replaceShellbox =
    fromList [
        ( '🔑', "KeyPrivateTok" )
      , ( '🔒', "KeyPublicTok" )
      , ( '🔐', "KeyPairTok" )
      , ( '❗', "IdentifierTok" )
    ]
-}

