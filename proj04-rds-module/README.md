1. Understand RDS resource and which necessary resources we need
2. Create a module with standard structure
3. Implement variable validation
4. Implement networking validation
   a. Receive subnet ids and security group ids via variables
   b. For subnets:
   I. Make sure that they are not in the default VPC
   II.Make sure that they are private
   4.3 For security groups:
   a. Make sure there are no inbound rules for IP addresses
5. Create necessary resources and make sure the validation is working
6. Create the RDS instance inside of the module
