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
{-# OPTIONS_GHC -Wno-unused-imports #-}
module Main
(
    main,
) where

import Relude
import My

import Text.Pandoc.JSON
import Text.Pandoc
import Text.Pandoc.Walk
import Data.Aeson (fromJSON, toJSON)
import PackageInfo_colorized_keys qualified as PackageInfo
import AppLatex qualified as Latex
import Format
import Replace
import ColorizedKeysFilter


main :: IO ()
main = do
    toJSONFilter $ \case 
        Just (Format "latex")  -> walkPandoc FileFormatLatex
        Just (Format "pdf")    -> walkPandoc FileFormatLatex
        Just (Format "html")   -> walkPandoc FileFormatHTML
        Just (Format format)   -> infoError ("File format not known: " <> format)
        Nothing                -> infoError "No file format"


walkPandoc :: FileFormat -> Pandoc -> IO Pandoc
walkPandoc format pandoc = do

    let Pandoc meta blocks = pandoc

    colorized <- executingStateT def $ do

        colorizedVersion .= 0
        colorizedPandoc  .= pandoc
        colorizedReplace .= replace -- TODO: read meta
       
    usingReaderT colorized $ case format of
        FileFormatLatex  -> Latex.main pandoc
        FileFormatHTML   -> errorPandoc pandoc "HTML not implemeted (yet)"
        _                -> errorPandoc pandoc "FileFormatNotImplemented"
   
    where
      errorPandoc (Pandoc meta blocks) str = 
          pure $ Pandoc meta ((Header 1 ("error", [], []) [Str str]) : blocks)
      


--------------------------------------------------------------------------------
--  TODO: don't putTextLn because the output is fed into the JSON pipe

--info msg = \a -> pure a <* putTextLn $ (toText PackageInfo.name) <> ": " <> msginfoError :: (MonadIO m) => Text -> a -> m a

infoError :: MonadIO m => Text -> a -> m a
infoError msg = \a ->
    --pure a <* (putTextLn $ toText PackageInfo.name <> ": " <> msg)
    pure a -- ^ FIXME: msg to stderr
