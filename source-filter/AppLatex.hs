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
import Text.Pandoc.Walk
import Data.Attoparsec.Text
import Data.Char (isSpace)
import App
import Replace



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

main :: Pandoc -> AppLatex Pandoc
main = do

    -- TODO: setup environment

    walkM $ \block -> case block of
      
        (CodeBlock atts@(id, cs, kvs) text) -> case cs of

            (language:cs) -> do

                case replace !? language of
                    Nothing   -> pure $ CodeBlock atts $ text <> "\n\n (not a colorize language) " <> show atts
                    Just map  -> do

                        --pure $ RawBlock (Format "latex") $ replaceLatex map $ text
                        pure $ CodeBlock atts $ replaceLatex map $ text

            []            -> pure block

        _ -> pure block
   
 
--------------------------------------------------------------------------------
--  

(<<>>) :: (Applicative f, Monoid a) => f a -> f a -> f a
(<<>>) fa0 fa1 =
    pure (<>) <*> fa0 <*> fa1 


replaceLatex :: ReplaceLanguage -> Text -> Text
replaceLatex replacers = \text ->
    case parseOnly (pReplaceLatex replacers) text of -- <* endOfInput?
        Left err    -> wrapLatexError $ toText err
        Right text' -> text'


pReplaceLatex :: ReplaceLanguage -> Parser Text
pReplaceLatex replacers = do
    t <- takeTill (`member` replacers)
    peekChar >>= \case 
        Nothing   -> pure t
        _         -> pure t <<>> do

            key <- anyChar -- <=> satisfy (`member` replacers)
            peekChar >>= \case 
                Just '['  -> do
                    str <- (char '[' *> takeTill (== ']') <* char ']') <?> "Missing enclosing ]"
                    pure (wrapLatex (replacers !? key ?: "\\") str) <<>> pReplaceLatex replacers

                _         -> do
                    str <- takeTill isSpace -- takeWhile1 (not . isSpace) forces at least 1
                    pure (wrapLatex (replacers !? key ?: "\\") str) <<>> pReplaceLatex replacers



--------------------------------------------------------------------------------
--  

wrapLatex :: Text -> Text -> Text
wrapLatex tok str =
    "\\" <> tok <> "{" <> str <> "}"


-- | some wrapping to indicate error
wrapLatexError :: Text -> Text
wrapLatexError str = 
    "\\textsc{ colorized-keys: " <> str <> "}"
    


