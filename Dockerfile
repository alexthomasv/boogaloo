## Dockerfile for a haskell environment
## TAG 7.8.4-bionic
##
FROM       buildpack-deps:bionic

## ensure locale is set during build
ENV LANG C.UTF-8

## for apt to be noninteractive
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN apt-get update && \
    apt-get install -y --no-install-recommends gnupg ca-certificates dirmngr curl git software-properties-common && \
    apt-add-repository -y "ppa:hvr/ghc" && \
    apt-get update && \
    apt-get install -y --no-install-recommends ghc-7.8.4 cabal-install-3.4 \
        ghc-7.8.4-prof libtinfo-dev && \
    rm -rf "$GNUPGHOME" /var/lib/apt/lists/* /stack.tar.gz

ENV PATH /root/.cabal/bin:/root/.local/bin:/opt/cabal/3.4/bin:/opt/ghc/7.8.4/bin:$PATH
# Set working directory
WORKDIR /opt
# Clone the Z3 repository and checkout version 4.7.1
RUN git clone https://github.com/Z3Prover/z3.git && \
    cd z3 && \
    git checkout z3-4.7.1 && \
    ./configure && \
    cd build && \
    make -j$(nproc) && \
    make install

RUN apt-get update && \
    apt-get install -y --no-install-recommends vim

WORKDIR /opt
# Install Boogaloo dependencies
RUN cabal update && cabal install --lib \
    StateVar-1.2.2 \
    adjunctions-4.4.2 \
    ansi-terminal-0.11.4 \
    ansi-wl-pprint-0.6.9 \
    array-0.5.0.0 \
    base-4.7.0.2 \
    base-orphans-0.8.8.2 \
    bifunctor-classes-compat-0.1 \
    bifunctors-5.5.15 \
    binary-0.7.1.0 \
    bytestring-0.10.4.0 \
    cabal-doctest-1.0.9 \
    colour-2.3.3 \
    comonad-5.0.8 \
    contravariant-1.5.5 \
    deepseq-1.3.0.2 \
    directory-1.2.1.0 \
    distributive-0.6.2.1 \
    exceptions-0.10.8 \
    fail-4.9.0.0 \
    filepath-1.3.0.2 \
    foldable1-classes-compat-0.1 \
    free-4.12.4 \
    generic-deriving-1.14.5 \
    ghc-prim-0.3.1.0 \
    hashable-1.2.7.0 \
    html-1.0.1.2 \
    indexed-traversable-0.1.3 \
    integer-gmp-0.5.1.0 \
    invariant-0.6.3 \
    kan-extensions-5.2.5 \
    lens-4.15.2 \
    logict-0.5.0.2 \
    mtl-2.1.3.1 \
    nats-1.1.2 \
    old-locale-1.0.0.6 \
    parallel-3.2.2.0 \
    parsec-3.1.17.0 \
    prelude-extras-0.4.0.3 \
    pretty-1.1.1.1 \
    primitive-0.7.2.0 \
    process-1.2.0.0 \
    profunctors-5.2.2 \
    random-1.0.1.1 \
    reflection-2.1.8 \
    semigroupoids-5.3.7 \
    semigroups-0.20 \
    stm-2.5.3.1 \
    stream-monad-0.4.0.2 \
    syb-0.7.2.4 \
    tagged-0.8.8 \
    template-haskell-2.9.0.0 \
    text-1.2.4.1 \
    th-abstraction-0.5.0.0 \
    time-1.4.2 \
    transformers-0.3.0.0 \
    transformers-compat-0.7.2 \
    unix-2.7.0.1 \
    unordered-containers-0.2.14.0 \
    vector-0.12.3.1 \
    void-0.7.3 \
    z3-4.3.1

# Set environment variables
ENV PATH="/root/.cabal/bin:${PATH}"

## run ghci by default unless a command is specified
CMD ["ghci"]
