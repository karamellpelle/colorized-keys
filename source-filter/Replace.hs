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
module Replace
(
    Replace,
    ReplaceLanguage,

    replace,
    replaceShellbox,

) where

import Relude
import My

import Relude.Extra.Map
import Data.Yaml

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

type Replace = Map Text ReplaceLanguage

type ReplaceLanguage = Map Char Text


--instance FromJSON ReplaceLanguage where
--    parseJSON = 

--instance FromJSON ReplaceLanguage where
--
--
--
--instance FromJSON ReplaceLanguage where
--    parseJSON = withObject "ReplaceLanguage" $ \v -> 
--         
--        fromList $ map (second parseJSON) $ toPairs v
--        fromList $ map (second parseJSON) $ toPairs v 


--
--
--instance FromJSON Replace where
--    parseJSON = withObject "Replace" $ \v -> 
--        fromList $ map (second parseJSON) $ toPairs v 
