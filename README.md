# Nagios core with NRDP docker image :whale:

This is a simple image with nagios core, its plugins and nrdp package.

# Build & Run
### Build the image
 * `docker build -t nagios .`
### Run container
 * `docker run --name nagios -p 4000:80  nagios`

# Test

### Check nagios core
 * `localhost:4000/nagios`
### Check NRDP
 * `localhot:4000/nrdp`

# User, passwords & tokens

|  user | password  |
|---|---|
|nagiosadmin   |nagios   |




|  NRDP tokens | 
|---|
|testtoken|
