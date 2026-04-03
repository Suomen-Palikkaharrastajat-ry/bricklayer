module Main where

import Test.Tasty
import qualified Bricklayer.BlockifySpec as Blockify

main :: IO ()
main = defaultMain $ testGroup "bricklayer"
    [ Blockify.tests
    ]
