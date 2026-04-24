const dgram = require('dgram');
const server = dgram.createSocket('udp4');

const PORT = 4210;
const HOST = '0.0.0.0';

server.on('listening', () => {
  const address = server.address();
  console.log(`\n🛸 Zentak Aero Mock Drone Server Listening on ${address.address}:${address.port}`);
  console.log('-----------------------------------------------------------------');
});

server.on('message', (message, remote) => {
  const data = message.toString();
  
  // Print incoming control data
  process.stdout.write(`\r📥 Incoming Data: [${data}] from ${remote.address}:${remote.port}   `);

  // Mock Telemetry Logic: Send mock data back to the app
  // Format: "B:98,P:2,R:-1" (Battery, Pitch, Roll)
  const mockTelemetry = `B:98,P:${Math.floor(Math.random() * 5)},R:${Math.floor(Math.random() * 5)}`;
  const buffer = Buffer.from(mockTelemetry);
  
  server.send(buffer, 0, buffer.length, remote.port, remote.address, (err) => {
    if (err) console.error('Error sending telemetry:', err);
  });
});

server.bind(PORT, HOST);
