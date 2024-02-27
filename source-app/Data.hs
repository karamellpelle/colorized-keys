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
module Data
(
    pathData,
    pathTemplateLaTeX,
    pathTemplateCodeBlock,
    --pathText,
    --pathGraphics,

    decodeFS,

) where
import Relude
import My

import Paths_colorized_keys
import PackageInfo_colorized_keys qualified as PackageInfo
import System.FilePath qualified as Legacy
import System.OsPath
import System.Directory.OsPath


pathData :: MonadIO m => Legacy.FilePath -> m OsPath
pathData path = io $ do
    dir <- encodeUtf =<< getDataFileName PackageInfo.name
    path' <- encodeUtf path
    pure $ dir </> path'
    
--appoptTemplatesDir <~ decodeUtf8 =<< getTemplateCodeBlock "" 


pathTemplateLaTeX :: MonadIO m => m OsPath
pathTemplateLaTeX = 
    pathData "default.latex"

pathTemplateCodeBlock :: MonadIO m => Legacy.FilePath -> m OsPath
pathTemplateCodeBlock name = 
    pathData $ Legacy.combine "codeblock-templates" name

--
--pathText :: Legacy.FilePath -> PandocApp OsPath
--pathText = 
--
--pathGraphics :: Legacy.FilePath -> IO OsPath
--pathGraphics = undefined
--

--getGlobalFileName :: MonadIO m => Legacy.FilePath -> m Legacy.FilePath
--getGlobalFileName path = io $ getDataFileName (packageInfo_name </> path)
--
--getLocalFileName :: MonadIO m => Legacy.FilePath -> m Legacy.FilePath
--getLocalFileName path = do
--    dir <- io $ getXdgDirectory XdgConfig packageInfo_name 
--    return $ dir </> path
--
