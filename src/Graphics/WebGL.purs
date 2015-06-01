module Graphics.WebGL where

import Debug.Trace

import Data.Maybe (Maybe (..))
import Graphics.Canvas (Canvas (), CanvasElement (), getCanvasElementById)

import qualified Graphics.WebGL.Raw.Enums as Enum
import qualified Graphics.WebGL.Raw       as Raw

import Control.Monad
import Control.Monad.Eff
import Control.Monad.Eff.Class
import Control.Monad.Free
import Control.Monad.Reader.Trans
import Control.Monad.Reader.Class
import Data.Coyoneda
import Data.Either
import Data.Function
import Data.Traversable
import Graphics.WebGL.Raw.Types

foreign import data WebGLCanvas :: *

type WebGLContextAttrs =
  { alpha                           :: Boolean
  , depth                           :: Boolean
  , stencil                         :: Boolean
  , antialias                       :: Boolean
  , premultipliedAlpha              :: Boolean
  , preserveDrawingBuffer           :: Boolean
  , preferLowPowerToHighPerformance :: Boolean
  , failIfMajorPerformanceCaveat    :: Boolean
  }

defaultWebGLContextAttrs :: WebGLContextAttrs
defaultWebGLContextAttrs =
  { alpha:                            true
  , depth:                            true
  , stencil:                          false
  , antialias:                        true
  , premultipliedAlpha:               true
  , preserveDrawingBuffer:            false
  , preferLowPowerToHighPerformance:  false
  , failIfMajorPerformanceCaveat:     false
  }

foreign import getWebGLContextWithAttrsImpl """
  function getWebGLContextImpl(canvas, attrs, Just, Nothing) {
    return function () {
      try {
        return Just(
          canvas.getContext('webgl', attrs) || canvas.getContext('experimental-webgl', attrs)
        );
      } catch(err) {
        return Nothing;
      };
    }
  }
""" :: forall eff maybe. Fn4 CanvasElement WebGLContextAttrs (WebGLContext -> maybe) maybe (Eff (canvas :: Canvas | eff) (Maybe WebGLContext))

getWebGLContextWithAttrs :: forall eff. CanvasElement -> WebGLContextAttrs -> Eff (canvas :: Canvas | eff) (Maybe WebGLContext)
getWebGLContextWithAttrs canvas attrs = runFn4 getWebGLContextWithAttrsImpl canvas attrs Just Nothing

getWebGLContext :: forall eff. CanvasElement -> Eff (canvas :: Canvas | eff) (Maybe WebGLContext)
getWebGLContext canvas = getWebGLContextWithAttrs canvas defaultWebGLContextAttrs

-- webgl monad HOMG

data BufferType = Depth | Color | Stencil

toBufferBit :: BufferType -> Number
toBufferBit Depth   = Enum.depthBufferBit
toBufferBit Color   = Enum.colorBufferBit
toBufferBit Stencil = Enum.stencilBufferBit

data WebGLError = WebGLError

type WebGL a = forall eff. ReaderT WebGLContext (Either WebGLError) (Eff (canvas :: Canvas | eff) a)

isContextLost :: WebGL Boolean
isContextLost = Raw.isContextLost <$> ask

getError :: WebGL Number
getError = Raw.getError <$> ask

myProg :: WebGL Boolean
myProg = do
    bool <- isContextLost
    num <- getError
    return bool

main :: forall eff. Eff (canvas :: Canvas | eff) (Either WebGLError Boolean)
main = do
  (Just el) <- getCanvasElementById "webgl"
  (Just gl) <- getWebGLContext el
  sequence $ runReaderT myProg gl
