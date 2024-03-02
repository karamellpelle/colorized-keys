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
module App
(
    runApp,
    AppM,

) where

import Relude
import My

import Text.Pandoc
import Text.Pandoc.Walk

--------------------------------------------------------------------------------
--  AppM

-- | application environment monad
type AppM d = ReaderT d IO


runApp :: (Walkable a Pandoc, Default d) => (a -> AppM d a) -> a -> IO a
runApp fm a = 
    usingReaderT def $ fm a
