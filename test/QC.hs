module Test where

import Control.Monad
import Data.ByteString.Lazy as ByteString hiding (last)
import Data.ByteString.Lazy.Char8 (last, lines)
import Lib
import Prelude as P hiding (concat, init, last, lines, readFile)
import System.Directory
import System.IO hiding (hPutStr, readFile)
import Test.QuickCheck
import Test.QuickCheck.Instances
import Test.QuickCheck.Monadic

cutNewLine :: ByteString.ByteString -> ByteString.ByteString
cutNewLine t
  | not (ByteString.null t) && (last t == '\n') = init t
  | otherwise = t

prop_doubleReverse :: ByteString.ByteString -> Property
prop_doubleReverse t =
  (cutNewLine . reverseLines . reverseLines) t === cutNewLine t

prop_reversedLength :: ByteString.ByteString -> Property
prop_reversedLength t =
  (ByteString.length . cutNewLine . reverseLines) t ===
  (ByteString.length . cutNewLine) t

prop_reversedLengths :: ByteString.ByteString -> Property
prop_reversedLengths t =
  (fmap ByteString.length . lines . reverseLines) t ===
  (fmap ByteString.length . lines) t

prop_readFile :: ByteString.ByteString -> Property
prop_readFile content =
  monadicIO $ do
    (file, handle) <- run $ openTempFile "./test" ".test"
    run $ hPutStr handle content
    run $ hClose handle
    testFunc <- run $ readFiles [file]
    stdFunc <- run $ readFile file
    run $ removeFile file
    assert $ testFunc == stdFunc

prop_readFiles :: [ByteString.ByteString] -> Property
prop_readFiles contents =
  monadicIO $ do
    (files, handles) <-
      run $
      fmap P.unzip . replicateM (P.length contents) $
      openTempFile "./test" ".test"
    run $ zipWithM_ hPutStr handles contents
    run $ mapM_ hClose handles
    testFunc <-
      run $
      if P.null files
        then return empty
        else readFiles files
    stdFunc <- run $ mapM readFile files
    run $ mapM_ removeFile files
    assert $ testFunc == concat stdFunc

main :: IO ()
main = do
  quickCheckWith stdArgs {maxSuccess = 1000} prop_doubleReverse
  quickCheckWith stdArgs {maxSuccess = 1000} prop_reversedLength
  quickCheckWith stdArgs {maxSuccess = 1000} prop_reversedLengths
  quickCheckWith stdArgs {maxSuccess = 1000} prop_readFile
  quickCheckWith stdArgs {maxSuccess = 100} prop_readFiles
