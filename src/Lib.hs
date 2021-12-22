{-# LANGUAGE NoImplicitPrelude #-}

-- |
-- Module      : $Header$
-- Description : for reverse
-- Copyright   : (c) 2021 Pavel Tsialnou
-- License     : MIT
-- Maintainer  : paveltsialnou@icloud.com
-- Stability   : experimental
--
-- Provides 'readFiles' and 'reverseLines' functions.
--
-- @since 0.1.0.0
module Lib
  ( readFiles
  , reverseLines
  ) where

import Control.Applicative ((<$>))
import Control.Monad (fmap, mapM)
import Data.ByteString.Lazy (ByteString, concat, getContents, readFile, reverse)
import Data.ByteString.Lazy.Char8 (lines, unlines)
import Data.Function ((.))
import System.IO (FilePath, IO())

-- |
-- Read files either from args list or standard input:
--
-- >>> import Data.ByteString.Lazy as BL
-- >>> readFiles ["Setup.hs"] >>= BL.putStrLn
-- import Distribution.Simple
-- main :: IO ()
-- main = defaultMain
--
-- @since 0.1.0.0
readFiles :: [FilePath] -> IO ByteString
readFiles [] = getContents
readFiles fs = concat <$> mapM readFile fs

-- |
-- Split lines, reverse each of them and concat them back:
--
-- >>> import Data.ByteString.Lazy as BL
-- >>> reverseLines $ BL.pack "Oops, I did it again!"
-- "!niaga ti did I ,spoO\n"
--
-- @since 0.1.0.0
reverseLines :: ByteString -> ByteString
reverseLines = unlines . fmap reverse . lines
