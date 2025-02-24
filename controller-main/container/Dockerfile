# SPDX-FileCopyrightText: OpenTalk GmbH <mail@opentalk.eu>
#
# SPDX-License-Identifier: EUPL-1.2

FROM rust:slim AS Builder

WORKDIR /controller

RUN apt-get update && apt-get install -y libpq-dev protobuf-compiler

COPY ./crates/cache/Cargo.toml ./crates/cache/Cargo.toml
COPY ./crates/chat/Cargo.toml ./crates/chat/Cargo.toml
COPY ./crates/ci-doc-updater/Cargo.toml ./crates/ci-doc-updater/Cargo.toml
COPY ./crates/client/Cargo.toml ./crates/client/Cargo.toml
COPY ./crates/client-shared/Cargo.toml ./crates/client-shared/Cargo.toml
COPY ./crates/community-modules/Cargo.toml ./crates/community-modules/Cargo.toml
COPY ./crates/controller/Cargo.toml ./crates/controller/Cargo.toml
COPY ./crates/controller-settings/Cargo.toml ./crates/controller-settings/Cargo.toml
COPY ./crates/controller-utils/Cargo.toml ./crates/controller-utils/Cargo.toml
COPY ./crates/core/Cargo.toml ./crates/core/Cargo.toml
COPY ./crates/database/Cargo.toml ./crates/database/Cargo.toml
COPY ./crates/db-storage/Cargo.toml ./crates/db-storage/Cargo.toml
COPY ./crates/etherpad-client/Cargo.toml ./crates/etherpad-client/Cargo.toml
COPY ./crates/integration/Cargo.toml ./crates/integration/Cargo.toml
COPY ./crates/janus-client/Cargo.toml ./crates/janus-client/Cargo.toml
COPY ./crates/janus-media/Cargo.toml ./crates/janus-media/Cargo.toml
COPY ./crates/jobs/Cargo.toml ./crates/jobs/Cargo.toml
COPY ./crates/keycloak-admin/Cargo.toml ./crates/keycloak-admin/Cargo.toml
COPY ./crates/kustos/Cargo.toml ./crates/kustos/Cargo.toml
COPY ./crates/kustos-prefix/Cargo.toml ./crates/kustos-prefix/Cargo.toml
COPY ./crates/kustos-prefix-impl/Cargo.toml ./crates/kustos-prefix-impl/Cargo.toml
COPY ./crates/kustos-shared/Cargo.toml ./crates/kustos-shared/Cargo.toml
COPY ./crates/lapin-pool/Cargo.toml ./crates/lapin-pool/Cargo.toml
COPY ./crates/log/Cargo.toml ./crates/log/Cargo.toml
COPY ./crates/mail-worker-protocol/Cargo.toml ./crates/mail-worker-protocol/Cargo.toml
COPY ./crates/nextcloud-client/Cargo.toml ./crates/nextcloud-client/Cargo.toml
COPY ./crates/proc-macro-fields-helper/Cargo.toml ./crates/proc-macro-fields-helper/Cargo.toml
COPY ./crates/timer/Cargo.toml ./crates/timer/Cargo.toml
COPY ./crates/whiteboard/Cargo.toml ./crates/whiteboard/Cargo.toml
COPY ./crates/polls/Cargo.toml ./crates/polls/Cargo.toml
COPY ./crates/r3dlock/Cargo.toml ./crates/r3dlock/Cargo.toml
COPY ./crates/redis-args/Cargo.toml ./crates/redis-args/Cargo.toml
COPY ./crates/redis-args-impl/Cargo.toml ./crates/redis-args-impl/Cargo.toml
COPY ./crates/protocol/Cargo.toml ./crates/protocol/Cargo.toml
COPY ./crates/shared-folder/Cargo.toml ./crates/shared-folder/Cargo.toml
COPY ./crates/signaling-core/Cargo.toml ./crates/signaling-core/Cargo.toml
COPY ./crates/test-util/Cargo.toml ./crates/test-util/Cargo.toml
COPY ./crates/types/Cargo.toml ./crates/types/Cargo.toml
COPY ./crates/main/Cargo.toml ./crates/main/Cargo.toml
COPY ./crates/diesel-newtype/Cargo.toml ./crates/diesel-newtype/Cargo.toml
COPY ./crates/diesel-newtype-impl/Cargo.toml ./crates/diesel-newtype-impl/Cargo.toml
COPY ./xtask/Cargo.toml ./xtask/Cargo.toml
COPY ./Cargo.toml ./Cargo.toml
COPY ./Cargo.lock ./Cargo.lock

RUN find crates -mindepth 1 -maxdepth 1 -type d -exec mkdir {}/src \; -exec touch {}/src/lib.rs \;
RUN mkdir -p crates/main/src xtask/src
# We need a proper main.rs to make the first cargo build run
RUN echo 'fn main() {println!("Hello World!");}' > crates/main/src/main.rs
RUN echo 'fn main() {println!("Hello World!");}' > xtask/src/main.rs
# As we haven't copied any source files yet, this will only compile the dependencies
RUN cargo fetch --locked

# Now copy the real source over
COPY crates crates
# Cargo detects changes only by mtime
RUN touch crates/main/src/main.rs xtask/src/main.rs && find crates -iname lib.rs -exec touch {} \;
RUN cargo build --release --locked

FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y libpq5 ca-certificates

WORKDIR /controller

COPY --from=Builder /controller/target/release/opentalk-controller .
RUN ln -s opentalk-controller k3k-controller
COPY extra/example.toml config.toml

EXPOSE 11311
ENTRYPOINT [ "./opentalk-controller" ]
