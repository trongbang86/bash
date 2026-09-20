function tools.temporal.start() {
  nohup temporal server start-dev --db-file "${TMP:-/tmp}/temporal.db" > "${TMP:-/tmp}/temporal-server.log" 2>&1 &
  echo "Temporal server started. Logs: ${TMP:-/tmp}/temporal-server.log"
}

function tools.temporal.stop() {
  pkill -f "temporal server start-dev"
  echo "Temporal server stopped."
}
