-- Copyright (C) 2023 karamellpelle@hotmail.com
-- 
-- This file is part of 'subject'.
-- 
-- 'subject' is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
-- 
-- 'subject' is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with 'subject'.  If not, see <http://www.gnu.org/licenses/>.
--
module Pandoc
(
    writerTemplateL,
    writerVariablesL,
    module Text.Pandoc,

    lookupKey,
    inClass,
    identifier,
) where
import Relude
import My

import Text.Pandoc
import Lens.Micro
import Lens.Micro.TH


writerTemplateL :: Lens' WriterOptions (Maybe (Template Text))
writerTemplateL = lens writerTemplate (\o a -> o { writerTemplate = a  })

writerVariablesL :: Lens' WriterOptions (Context Text)
writerVariablesL = lens writerVariables (\o a -> o { writerVariables = a  })


--------------------------------------------------------------------------------
--  CodeBlock helpers

lookupKey :: Attr -> Text -> Maybe Text
lookupKey (_id, _classes, keymap) key =
    lookupKey k = lookup (fromList keymap)

inClass :: Attr -> Text -> Bool
inClass (_id, classes, _keymap) c = 
    elem c classes

identifier :: Attr -> Text
identifier (id, _classes, _keymap) =
    id

