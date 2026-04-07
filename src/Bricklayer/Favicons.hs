module Bricklayer.Favicons (generateFavicons) where

import Bricklayer.Raster (exportPngSquareTrimmed)
import Control.Monad (forM_)
import System.Directory (createDirectoryIfMissing)
import System.Process (callProcess)

{- | Generate all favicon assets from the square logo SVG.
The source SVG may not be perfectly square; exportPngSquare fits it
into an exact N×N canvas (with transparent padding) so all outputs are
square, as required by browser and OS favicon specifications.
-}
generateFavicons :: FilePath -> FilePath -> IO ()
generateFavicons squareSvgPath faviconDir = do
    createDirectoryIfMissing True faviconDir

    forM_ sizes $ \(sz, name, bg) ->
        exportPngSquareTrimmed squareSvgPath (faviconDir ++ "/" ++ name ++ ".png") sz bg

    -- Bundle 16, 32, 48, 64px PNGs into a multi-size favicon.ico
    callProcess
        "icotool"
        [ "--create"
        , "-o"
        , faviconDir ++ "/favicon.ico"
        , faviconDir ++ "/favicon-16.png"
        , faviconDir ++ "/favicon-32.png"
        , faviconDir ++ "/favicon-48.png"
        , faviconDir ++ "/favicon-64.png"
        ]

    putStrLn $ "  Wrote " ++ faviconDir ++ "/favicon.ico"
  where
    sizes :: [(Int, String, String)]
    sizes =
        -- Browser favicons (transparent — browsers render over tab chrome)
        [ (16, "favicon-16", "transparent")
        , (32, "favicon-32", "transparent")
        , (48, "favicon-48", "transparent")
        , (64, "favicon-64", "transparent")
        , -- Apple touch icons (#05131D — iOS does not support transparency)
          (120, "apple-touch-icon-120", "#05131D")
        , (152, "apple-touch-icon-152", "#05131D")
        , (167, "apple-touch-icon-167", "#05131D")
        , (180, "apple-touch-icon", "#05131D")
        , -- PWA icons (#05131D — Android webmanifest does not support transparency)
          (192, "icon-192", "#05131D")
        , (512, "icon-512", "#05131D")
        , -- Maskable icon (transparent — OS applies adaptive mask and supplies background)
          (512, "icon-maskable", "transparent")
        ]
