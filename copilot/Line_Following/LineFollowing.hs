module LineFollowing where

import Prelude ()
import Language.Copilot
import qualified Copilot.Compile.C99 as C

threshold = 700

spec :: Spec
spec = do
    let lineLeft   = externFun "sparki_lineLeft" [] Nothing :: Stream Int16
        lineCenter = externFun "sparki_lineCenter" [] Nothing :: Stream Int16
        lineRight  = externFun "sparki_lineRight" [] Nothing :: Stream Int16

        forward = lineCenter < threshold
        left    = not forward && lineLeft < threshold
        right   = not forward && lineRight < threshold

    trigger "sparki_moveForward" forward []
    trigger "sparki_moveLeft" left []
    trigger "sparki_moveRight" right []

    trigger "updateLCD" true [ arg lineLeft
                             , arg lineCenter
                             , arg lineRight
                             ]


main :: IO ()
main =
    reify spec >>= C.compile C.defaultParams
