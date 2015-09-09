{-# LANGUAGE OverloadedStrings #-}

-- | Downloads page view.

module HL.View.Downloads where

import Data.Monoid
import HL.Types
import HL.View
import HL.View.Template

-- | Downloads view.
downloadsV :: FromLucid App
downloadsV =
  template [] "Downloads"
    (\url ->
       container_
         (row_
            (span12_ [class_ "col-md-12"]
               (do h1_ "Downloads"
                   h2_ "Compiler and base libraries"
                   p_ "Downloads are available on a per operating system basis:"
                   ul_ (forM_ [minBound .. maxBound]
                              (\os ->
                                 li_ (a_ [href_ (url (DownloadsForR os))]
                                         (toHtml (toHuman os)))))
                   thirdParty))))

-- | OS-specific downloads view.
downloadsForV :: OS -> Html () -> Html () -> FromLucid App
downloadsForV os autoInstall manualInstall =
  template
    [DownloadsR
    ,DownloadsForR os]
    ("Downloads for " <> toHuman os)
    (\_ ->
       container_
         (row_
            (span12_ [class_ "col-md-12"]
               (do h1_ (toHtml ("Downloads for " <> toHuman os))
                   autoInstall
                   when (os == Linux)
                        (do h2_ "Manual install"
                            p_ "To install GHC and Cabal manually, follow these steps."
                            manualInstall)))))

thirdParty :: Html ()
thirdParty =
  do h2_ "Packages"
     stackage
     github

stackage :: Html ()
stackage =
  do h3_ "Stackage"
     p_ (do "Stackage is a repository of stable packages which are tested for\
            \ consistency with eachother. The packages are available immediately \
            \and documentation will be generated and hosted there. It can be \
            \used by "
            code_ "stack install"
            ".")
     p_ "You can install a package by merely running: "
     pre_ "$ stack install the-package"
     p_ (a_ [href_ "https://stackage.org/"] $ "Go to Stackage →")

github :: Html ()
github =
  do h3_ "Working with repositories"
     p_ "Working on a source repository is also possible. For example, \
        \to clone and work on the network package from source, you would run:"
     pre_ "$ git clone git@github.com:haskell/network.git\n\
          \$ cd network\n\
          \$ stack init\n\
          \$ stack install"
     p_ (a_ [href_ "https://github.com/trending?l=haskell&since=monthly"] $
            "Browse Github by Haskell repositories →")
