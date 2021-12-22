{-# LANGUAGE NoImplicitPrelude #-}

-- |
-- Module      : $Header$
-- Description : for reverse
-- Copyright   : (c) 2021 Pavel Tsialnou
-- License     : MIT
-- Maintainer  : paveltsialnou@icloud.com
-- Stability   : experimental
--
-- Provides 'main' function.
--
-- @since 0.1.0.0
module Main
  ( main
  ) where

import CLI (Reverse(files), reverse)
import Control.Monad ((>>=))
import Data.ByteString.Lazy (putStr)
import Data.Function ((.))
import Lib (readFiles, reverseLines)
import System.Console.CmdArgs (cmdArgs)
import System.IO (IO())

-- |
-- Parse app args, read files/stdin and print reversed into stdout
--
-- @since 0.1.0.0
main :: IO ()
main = (cmdArgs reverse >>= readFiles . files) >>= putStr . reverseLines
