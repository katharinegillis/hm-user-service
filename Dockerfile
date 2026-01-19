###
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS base

USER app
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

###
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
ARG BUILD_CONFIGURATION=Release
ARG VERSION=1.0.0
WORKDIR /src
COPY ["./Server", "/src/Server"]

WORKDIR /src/Server
RUN if [ "$VERSION" ]; \
    then dotnet build "Server.csproj" -c $BUILD_CONFIGURATION -o /app/build  /p:Version=$VERSION /p:AssemblyVersion=$VERSION /p:FileVersion=$VERSION; \
    else dotnet build "Server.csproj" -c $BUILD_CONFIGURATION -o /app/build; \
    fi 

###
FROM build AS publish
ARG BUILD_CONFIGURATION=Release

WORKDIR /src/Server
RUN dotnet publish "Server.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

###
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
COPY ./entrypoint.sh /app/entrypoint.sh

USER app
RUN echo "export PATH=/app:${PATH}" >> /home/app/.bashrc
ENV PATH=$PATH:/app
ENTRYPOINT ["/bin/bash", "/app/entrypoint.sh"]

###
FROM build AS build-test
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["./Server.Tests", "/src/Server.Tests"]

WORKDIR /src/Server.Tests
RUN dotnet build "Server.Tests.csproj" -c $BUILD_CONFIGURATION -o /app/build;

###
FROM build-test AS publish-test
ARG BUILD_CONFIGURATION=Release
WORKDIR /src/Server.Tests
RUN dotnet publish "Server.Tests.csproj" -c $BUILD_CONFIGURATION -o /app/publish-test
