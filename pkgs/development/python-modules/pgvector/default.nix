{ lib
, asyncpg
, buildPythonPackage
, django
, fetchFromGitHub
, numpy
, postgresql
, postgresqlTestHook
, psycopg
, psycopg2
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "pgvector";
  version = "0.1.8";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pgvector";
    repo = "pgvector-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-+0daPPZGVkqfZw0gOZwIl+knL/zZki9fs5kA3dYqPpE=";
  };

  propagatedBuildInputs = [
    numpy
  ];

  nativeCheckInputs = [
    asyncpg
    django
    (postgresql.withPackages (p: with p; [ pgvector ]))
    postgresqlTestHook
    psycopg
    psycopg2
    pytest-asyncio
    pytestCheckHook
    sqlalchemy
  ];

  env = {
    PGDATABASE = "pgvector_python_test";
    postgresqlEnableTCP = 1;
    postgresqlTestUserOptions = "LOGIN SUPERUSER";
  };

  pythonImportsCheck = [ "pgvector" ];

  meta = with lib; {
    description = "Pgvector support for Python";
    homepage = "https://github.com/pgvector/pgvector-python";
    changelog = "https://github.com/pgvector/pgvector-python/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
