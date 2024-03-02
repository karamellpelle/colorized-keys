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
import PackageInfo_colorized_keys qualified as PackageInfo
import App
import AppLatex qualified as Latex


main :: IO ()
main = do
    toJSONFilter $ \case 
        Just (Format "latex")  -> runApp $ Latex.main
        Just (Format "pdf")    -> runApp $ Latex.main
        Just (Format "html")   -> info $ "HTML not implemented yet"
        Just (Format format)   -> infoError $ "File format not known: " <> format
        Nothing                -> infoError $ "No file format"


--------------------------------------------------------------------------------
--  TODO: don't putTextLn because the output is fed into the JSON pipe


--info msg = \a -> pure a <* putTextLn $ (toText PackageInfo.name) <> ": " <> msg
info :: Text -> a -> IO a
info msg = \a -> 
    pure a <* (putTextLn $ toText PackageInfo.name <> ": " <> msg)

infoError :: Text -> a -> IO a
infoError msg = \a -> do
    pure a <* (putTextLn $ toText PackageInfo.name <> ": " <> msg)
