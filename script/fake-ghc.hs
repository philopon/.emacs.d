{-#LANGUAGE CPP #-}

import System.Environment
import System.Info
import Data.Version
import Control.Monad

main = do args <- getArgs
          if "--numeric-version" `elem` args
            then putStrLn $ showVersion compilerVersion
            else do putStrLn "== GHC Arguments: Start =="
                    mapM putStrLn args
                    putStrLn "== GHC Arguments: End =="