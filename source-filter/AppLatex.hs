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
    main,

) where

import Relude
import My

import Lens.Micro.TH
import System.FilePath
import Text.Pandoc
import Text.Pandoc.Walk
import Text.Pandoc.Highlighting
import Skylighting.Syntax
import Data.Attoparsec.Text
import Data.Char (isSpace)
import Relude.Extra.Newtype
import ColorizedData
import Skylighting.Parser
import Languages
import System.Directory






--------------------------------------------------------------------------------
--  

main :: Pandoc -> ColorizedApp Pandoc
main pandoc = do

    -- TODO: setup environment
    --
    walkBlock pandoc
    where
      walkBlock = walkM $ \block -> case block of
            
          (CodeBlock atts@(id, cs, kvs) text) -> case cs of

              (language:cs) -> do

                  languages <- view colorizedLanguages

                  case languages !? language of
                      Nothing   -> pure $ CodeBlock atts $ text <> "\n\n (not a colorize language) " <> show atts
                      Just (Language xml map) -> do

                          --pure $ RawBlock (Format "latex") $ replaceLatex map $ text
                          --pure $ CodeBlock atts $ replaceLatex map $ text
                          --
                          -- TODO: use values
                          --meta <- view appMeta
                          --case meta
                          path <- syntaxPath language =<< view colorizedDataDir
                          synmap <- io $ whenMA (doesFileExist path) defaultSyntaxMap $ parseSyntaxDefinition path >>= \case 
                              Left err     -> pure $ defaultSyntaxMap
                              Right syntax -> pure $ fromList $ one (language, syntax)

                          case highlight synmap formatLaTeXBlock atts text of
                              Left err    -> pure $ latexError language err 
                              Right text' -> pure $ RawBlock (Format "latex") $ replaceLatex map $ text' 


              []            -> pure block

          _ -> pure block

      latexError lang err = case err of
          ""  -> Para [Strong [Str $ "colorized-filter: syntax map not found: " <> lang ]]
          _   -> Para [Strong [Str $ "colorized-filter: highlighting error: " <> err]]
      syntaxPath language dir = pure $ dir </> "pandoc/syntax" </> toString language <.> ".xml"


pickMap :: MetaValue -> Text -> Maybe MetaValue
pickMap (MetaMap map) key = map !? key
pickMap _ key = Nothing


--------------------------------------------------------------------------------
--  

(<<>>) :: (Applicative f, Monoid a) => f a -> f a -> f a
(<<>>) fa0 fa1 =
    pure (<>) <*> fa0 <*> fa1 


replaceLatex :: EmojiMap -> Text -> Text
replaceLatex replacers = \text ->
    case parseOnly (pReplaceLatex replacers) text of -- <* endOfInput?
        Left err    -> wrapLatexError $ toText err
        Right text' -> text'


pReplaceLatex :: EmojiMap -> Parser Text
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
    


