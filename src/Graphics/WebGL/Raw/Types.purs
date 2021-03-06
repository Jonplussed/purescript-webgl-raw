module Graphics.WebGL.Raw.Types where

import Data.ArrayBuffer.Types

type DOMString        = String
type BufferDataSource = Float32Array
type FloatArray       = Float32Array
type GLbitfield       = Int
type GLboolean        = Boolean
type GLbyte           = Int
type GLclampf         = Number
type GLenum           = Int
type GLfloat          = Number
type GLint            = Int
type GLintptr         = Int
type GLshort          = Int
type GLsizei          = Int
type GLsizeiptr       = Int
type GLubyte          = Int
type GLuint           = Int
type GLushort         = Int

foreign import data ArrayBufferView :: *
foreign import data TexImageSource :: *
foreign import data WebGLActiveInfo :: *
foreign import data WebGLBuffer :: *
foreign import data WebGLContext :: *
foreign import data WebGLFramebuffer :: *
foreign import data WebGLProgram :: *
foreign import data WebGLRenderbuffer :: *
foreign import data WebGLShader :: *
foreign import data WebGLShaderPrecisionFormat :: *
foreign import data WebGLTexture :: *
foreign import data WebGLUniformLocation :: *

type WebGLContextAttributes =
  { alpha                           :: Boolean
  , depth                           :: Boolean
  , stencil                         :: Boolean
  , antialias                       :: Boolean
  , premultipliedAlpha              :: Boolean
  , preserveDrawingBuffer           :: Boolean
  , preferLowPowerToHighPerformance :: Boolean
  , failIfMajorPerformanceCaveat    :: Boolean
  }
