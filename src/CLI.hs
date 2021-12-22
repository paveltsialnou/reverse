{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE NoImplicitPrelude #-}

-- |
-- Module      : $Header$
-- Description : for reverse
-- Copyright   : (c) 2021 Pavel Tsialnou
-- License     : MIT
-- Maintainer  : paveltsialnou@icloud.com
-- Stability   : experimental
--
-- Provides 'Reverse' data and 'reverse' functions.
--
-- @since 0.1.0.0
module CLI
  ( Reverse(files)
  , reverse
  ) where

import Data.Data (Data)
import Data.Typeable (Typeable)
import System.Console.CmdArgs
  ( (&=)
  , args
  , def
  , explicit
  , help
  , helpArg
  , name
  , summary
  , typ
  , versionArg
  )
import System.IO (FilePath, IO())
import Text.Show (Show)

-- |
-- A structure to store args and flags
--
-- @since 0.1.0.0
data Reverse =
  Reverse
    { files :: [FilePath] -- ^ Files/stdin to read
    }
  deriving (Show, Data, Typeable)

-- |
-- Default args and flags
--
-- >>> reverse
-- Reverse {files = []}
--
-- @since 0.1.0.0
reverse :: Reverse
reverse =
  Reverse {files = def &= args &= typ "file ..."} &=
  help "Reverse lines characterwise." &=
  helpArg [explicit, help "display this help", name "h", name "help"] &=
  summary "Reverse, written in Haskell" &=
  versionArg [explicit, help "display version", name "V", name "version"]
