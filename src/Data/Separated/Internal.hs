{-# language DeriveFunctor #-}
{-# language DeriveFoldable #-}
{-# language DeriveTraversable #-}
{-# language TemplateHaskell #-}

module Data.Separated.Internal where

import Prelude (Show, uncurry)
import Control.Applicative
import Control.Lens
import Data.Bifoldable
import Data.Bitraversable
import Data.Deriving
import Data.Eq
import Data.Foldable
import Data.Functor
import Data.Monoid
import Data.Ord

-- | An @s@ that comes before an @a@
data Before s a = Before s a
  deriving (Eq, Foldable, Functor, Ord, Traversable, Show)

deriveEq1 ''Before
deriveShow1 ''Before
deriveOrd1 ''Before

instance Bifunctor Before where
  bimap f g (Before s a) = Before (f s) (g a)

-- | @'bifoldMap' f g ('Before' s a) = f s '<>' g a@
instance Bifoldable Before where
  bifoldMap f g (Before s a) = f s <> g a

-- | @'bitraverse' f g ('Before' s a) = 'Before' '<$>' f s '<*>' g a@
instance Bitraversable Before where
  bitraverse f g (Before s a) = Before <$> f s <*> g a

instance Swapped Before where
  swapped =
    iso
      (\(Before a b) -> Before b a)
      (\(Before b a) -> Before a b)

-- | @'Before' s a@ is isomorphic to @(s, a)@
before :: Iso (s, a) (t, b) (Before s a) (Before t b) 
before = iso (uncurry Before) (\(Before s a) -> (s, a))

-- | @'Before' s a@ is isomorphic to @'After' a s@
--
-- @'beforeAfter' == 'from' 'afterBefore'@
beforeAfter :: Iso (After a s) (After b t) (Before s a) (Before t b)
beforeAfter =
  iso
    (\(After a s) -> Before a s)
    (\(Before t b) -> After t b)

-- | An @s@ that comes after an @a@
data After s a = After a s
  deriving (Eq, Foldable, Functor, Ord, Traversable, Show)

deriveEq1 ''After
deriveShow1 ''After
deriveOrd1 ''After

instance Bifunctor After where
  bimap f g (After a s) = After (g a) (f s)

-- | @'bifoldMap' f g ('After' a s) = g a '<>' f s@
instance Bifoldable After where
  bifoldMap f g (After a s) = g a <> f s

-- | @'bitraverse' f g ('After' a s) = 'After' '<$>' g a '<*>' f s@
instance Bitraversable After where
  bitraverse f g (After a s) = After <$> g a <*> f s
  
instance Swapped After where
  swapped =
    iso
      (\(After a b) -> After b a)
      (\(After b a) -> After a b)

-- | @'After' s a@ is isomorphic to @(a, s)@
after :: Iso (a, s) (b, t) (After s a) (After t b)
after = iso (uncurry After) (\(After a s) -> (a, s))

-- | @'After' s a@ is isomorphic to @'Before' a s@
--
-- @'afterBefore' == 'from' 'beforeAfter'@
afterBefore :: Iso (Before s a) (Before t b) (After a s) (After b t) 
afterBefore = from beforeAfter
