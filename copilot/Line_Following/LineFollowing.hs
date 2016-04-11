module LineFollowing where

import Prelude ()
import Language.Copilot
import qualified Copilot.Compile.C99 as C

threshold = 700

spec :: Spec
spec = do
    let myExtVar = externW32 "myVal" Nothing
        lineLeft   = externFun "sparki_lineLeft" [] Nothing :: Stream Word32
        lineCenter = externFun "sparki_lineCenter" [] Nothing :: Stream Word32
        lineRight  = externFun "sparki_lineRight" [] Nothing :: Stream Word32

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
