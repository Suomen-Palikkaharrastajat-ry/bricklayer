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

    forM_ sizes $ \(sz, name, bg, paddingFraction) ->
        exportPngSquareTrimmed squareSvgPath (faviconDir ++ "/" ++ name ++ ".png") sz bg paddingFraction

    -- Bundle 16, 32, 48, 64px PNGs into a multi-size favicon.ico
    callProcess
        "icotool"
        [ "--create"
        , "-o"
        , faviconDir ++ "/favicon.ico"
        , faviconDir ++ "/favicon-16x16.png"
        , faviconDir ++ "/favicon-32x32.png"
        , faviconDir ++ "/favicon-48x48.png"
        , faviconDir ++ "/favicon-64x64.png"
        ]

    putStrLn $ "  Wrote " ++ faviconDir ++ "/favicon.ico"
  where
    sizes :: [(Int, String, String, Double)]
    sizes =
        -- Browser favicons (transparent — browsers render over tab chrome)
        [ (16, "favicon-16x16", "transparent", 0)
        , (32, "favicon-32x32", "transparent", 0)
        , (48, "favicon-48x48", "transparent", 0)
        , (64, "favicon-64x64", "transparent", 0)
        , -- Apple touch icons (#05131D / black — iOS does not support transparency)
          (120, "apple-touch-icon-120", "#05131D", 0.15)
        , (152, "apple-touch-icon-152", "#05131D", 0.15)
        , (167, "apple-touch-icon-167", "#05131D", 0.15)
        , (180, "apple-touch-icon", "#05131D", 0.15)
        , (192, "apple-touch-icon-192", "#05131D", 0.15)
        , (512, "apple-touch-icon-512", "#05131D", 0.15)
        , -- PWA icons (transparent — keep the source artwork alpha intact)
          (192, "icon-192", "transparent", 0)
        , (512, "icon-512", "transparent", 0)
        , -- Maskable icon matches Apple touch background and keeps safe-zone padding
          (512, "icon-maskable", "#05131D", 0.15)
        ]
