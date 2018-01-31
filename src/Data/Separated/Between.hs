{-# language DeriveFunctor #-}
{-# language DeriveFoldable #-}
{-# language DeriveTraversable #-}
{-# language TemplateHaskell #-}
module Data.Separated.Between
  ( -- * Datatypes
    Between(..)
  , Between'(..)
    -- * Isos
  , between
  , between'
  , betweens
  )
  where

import Prelude (Show)
import Control.Applicative
import Control.Lens
import Data.Bifoldable
import Data.Bitraversable
import Data.Deriving
import Data.Eq
import Data.Functor
import Data.Foldable
import Data.Monoid
import Data.Ord

-- | An @a@ with an @s@ on the left and a @t@ on the right
data Between s t a = Between s a t
  deriving (Eq, Foldable, Functor, Ord, Traversable, Show)

deriveEq1 ''Between
deriveShow1 ''Between
deriveOrd1 ''Between

-- | @'Between' s t a@ is isomorphic to @(s, a, t)@
between :: Iso (s, a, s') (t, b, t') (Between s s' a) (Between t t' b) 
between =
  iso
  (\(t, b, t') -> Between t b t')
  (\(Between s a s') -> (s, a, s'))

-- | An @a@ with an @s@ on each side
data Between' s a = Between' s a s
  deriving (Eq, Foldable, Functor, Ord, Traversable, Show)

deriveEq1 ''Between'
deriveShow1 ''Between'
deriveOrd1 ''Between'

instance Bifunctor Between' where
  bimap f g (Between' s a s') = Between' (f s) (g a) (f s')

-- | @'bifoldMap' f g ('Between'' s a s') = f s '<>' g a '<>' f s'@
instance Bifoldable Between' where
  bifoldMap f g (Between' s a s') = f s <> g a <> f s'
    
-- | @'bitraverse' f g ('Between'' s a s') = 'Between'' '<$>' f s '<*>' g a '<*>' f s'@
instance Bitraversable Between' where
  bitraverse f g (Between' s a s') = Between' <$> f s <*> g a <*> f s'

-- | @'Between'' s a@ is isomorphic to @(s, a, s)@
between' :: Iso (s, a, s) (t, b, t) (Between' s a) (Between' t b) 
between' =
  iso
  (\(t, b, t') -> Between' t b t')
  (\(Between' s a s') -> (s, a, s'))

-- | @'Between'' s a@ is isomorphic to @'Between' s s a@
betweens :: Iso (Between s s a) (Between t t b) (Between' s a) (Between' t b)
betweens =
  iso
  (\(Between t b t') -> Between' t b t')
  (\(Between' s a s') -> Between s a s')
