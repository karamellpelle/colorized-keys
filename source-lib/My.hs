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
module My 
(
    module Lens.Micro, 
    module Lens.Micro.Mtl, 
    module Data.Default,
    module Relude.Extra.Map,
    MonadError,
    throwError,
    catchError,
    handleError,

    UInt,
    io,

) where

import Relude
import Relude.Extra.Map
import Lens.Micro
import Lens.Micro.Mtl
import Data.Default
import Control.Monad.Except (MonadError, throwError, catchError, handleError)
--import Control.Monad.Except (MonadError, throwError, catchError)

type UInt = Word

io :: MonadIO m => IO a -> m a
io = liftIO
{-# INLINE io #-}
