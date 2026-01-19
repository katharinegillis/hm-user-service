###
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS base

USER app
WORKDIR /app
EXPOSE 5095

###
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS copy-files
WORKDIR /src
COPY ["./Server", "/src/Server"]

###
FROM copy-files AS publish
ARG BUILD_CONFIGURATION=Release
ARG VERSION=1.0.0

WORKDIR /src/Server
RUN if [ "$VERSION" ]; \
    then dotnet publish "Server.csproj" -c $BUILD_CONFIGURATION -o /app/publish  /p:Version=$VERSION /p:AssemblyVersion=$VERSION /p:FileVersion=$VERSION; \
    else dotnet publish "Server.csproj" -c $BUILD_CONFIGURATION -o /app/publish; \
    fi 

###
FROM base AS final
ENV ASPNETCORE_URLS=http://0.0.0.0:5095
ENV ASPNETCORE_ENVIRONMENT=$BUILD_CONFIGURATION
WORKDIR /app
COPY --from=publish /app/publish .

USER app
RUN echo "export PATH=/app:${PATH}" >> /home/app/.bashrc
ENV PATH=$PATH:/app
CMD /app/Server

###
FROM copy-files AS publish-test
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["./Server.Tests", "/src/Server.Tests"]

WORKDIR /src/Server.Tests
RUN dotnet publish "Server.Tests.csproj" -c $BUILD_CONFIGURATION -o /app/publish-test;
