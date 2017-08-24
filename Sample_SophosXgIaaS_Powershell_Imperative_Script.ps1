<# ================================================================================================================ 
:: DESCRIPTION : This script auto deploys the Sophos XG firewall on Azure with 3 LANS and 3 servers behind it 
:: AUTHOR      : David Okeyode. 
:: VERSION     : 1.0.0
:: ================================================================================================================ 
#>

### Define the variables for the deployment
{
# This is the Azure region where this workload will be deployed to. You can use the above code to verify the location that the Sophos publisher is available
$location = 'West Europe'

# Every resource in Azure lives in a resource group. Specify what you'll like this to be called
$rgName = "xgAzureRG"

# Specify the name of the virtual network
$vnetName = "xgAzurevNet"

# Specify the address space of the virtual network. If you intend to connect this to an On-Prem DC, avoid using a conflicting address space
$vnetAddressSpace = "10.0.0.0/16"

# This is the subnet that the WAN interface card of the XG firewall will connect to. Only the XG firewall will connect to this subnet. It must be within the address space specified above
$wanSubnetPrefix = "10.0.0.0/24"

# These are the LAN subnets that the XG firewall will be protecting. They must be within the address space that was specified above
$lan1SubnetPrefix = "10.0.1.0/24"
$lan2SubnetPrefix = "10.0.2.0/24"
$lan3SubnetPrefix = "10.0.3.0/24"

# Specify static IPs
$xgPrivateIPLan1 = "10.0.1.5"
$xgPrivateIPLan2 = "10.0.2.5"
$xgPrivateIPLan3 = "10.0.3.5"

# The virtual hard drives will be stored in a storage account. Specify the name for the account. 
# This must be between 3 and 24 characters in length and use numbers and lower-case letters only.
$storageAccountName = "xgazurestore"

# Specify the name of the storage container where the VHDs will be stored
$storageContainerName = "vhds"

# Specify the names of the network interface cards of the XG firewall
$xgWanNicName = "xgWanNic"
$xgLan1NicName = "xgLan1Nic"
$xgLan2NicName = "xgLan2Nic"
$xgLan3NicName = "xgLan3Nic"

# Specify the name of the public IP
$xgWanNicPublicIPName = "xgWanNicPIP"

# Specify your public domain name that will be used for the WAN interface card of the XG appliance
$publicIPDnsName = "lightbulbit.co.uk"

# Specify the name of your Sophos XG firewall VM
$xgVmName = "lbazurexg1"

# Specify the prefix name for the Server VMs
$srvNamePrefix = "lbazurelan"
 
# Specify the disk name of your Sophos XG firewall VM
# $xgVmDiskName = "lbazurexg1"

# Specify the size of the Sophos XG firewall VM. Only sizes that support a minimum of 2 NICs are supported. Refer here - https://azure.microsoft.com/en-gb/documentation/articles/virtual-machines-windows-sizes
$xgVmSize = "Standard_D3"

# Specify the size of the Server VMs
$srvVmSize = "Standard_A1"

# Specify the admin credentials for your firewall appliance. The username is just a placeholder. The webadmin username of the XG after deployment will still be "admin". Use a strong password.
$adminUsername = "azureadmin"
$adminPassword = "Pa$$w0rd123"

# Specify the SKU of the Sophos Firewall that you'll like to deploy. "BYOL" for Bring Your Own License or "PAYG" for Pay As You Go.
$xgSkuName = "byol"

# Specify the names of the custom route tables that will be applied to the LAN subnets
$lan1RouteTableName = "Lan1SubnetRouteTable"
$lan2RouteTableName = "Lan2SubnetRouteTable"
$lan3RouteTableName = "Lan3SubnetRouteTable"
}

### Create the resource group, the storage account and the storage container (to store the VHDs)
{
New-AzureRmResourceGroup -Name $rgName -Location $location
New-AzureRmStorageAccount -ResourceGroupName $rgName -Name $storageAccountName -Type Standard_LRS -Location $location

# Set the newly created storage account as the subscription default
Set-AzureRmCurrentStorageAccount -ResourceGroupName $rgName -Name $storageAccountName

# Create a new container that we'll store our VHDs in
New-AzureStorageContainer -Name $storageContainerName -Permission Off
}

### Create the virtual network and subnets
{
$xgWanSubnet = New-AzureRmVirtualNetworkSubnetConfig -Name "xgWanSubnet" -AddressPrefix $wanSubnetPrefix
$xgLan1Subnet = New-AzureRmVirtualNetworkSubnetConfig -Name "xgLan1Subnet" -AddressPrefix $lan1SubnetPrefix
$xgLan2Subnet = New-AzureRmVirtualNetworkSubnetConfig -Name "xgLan2Subnet" -AddressPrefix $lan2SubnetPrefix
$xgLan3Subnet = New-AzureRmVirtualNetworkSubnetConfig -Name "xgLan3Subnet" -AddressPrefix $lan3SubnetPrefix
New-AzureRmVirtualNetwork `
-Name $vnetName `
-ResourceGroupName $rgName `
-Location $location `
-AddressPrefix $vnetAddressSpace `
-Subnet $xgWanSubnet, $xgLan1Subnet, $xgLan2Subnet, $xgLan3Subnet
}

### Create the Network Interfaces and Public IP
{
# Create the public IP that will be used by the XG WAN NIC
$vnet = Get-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName
$xgWanSubnetID = (Get-AzureRmVirtualNetworkSubnetConfig -Name $xgWanSubnet.Name -VirtualNetwork $vnet).Id
$xgLan1SubnetID = (Get-AzureRmVirtualNetworkSubnetConfig -Name $xgLan1Subnet.Name -VirtualNetwork $vnet).Id
$xgLan2SubnetID = (Get-AzureRmVirtualNetworkSubnetConfig -Name $xgLan2Subnet.Name -VirtualNetwork $vnet).Id
$xgLan3SubnetID = (Get-AzureRmVirtualNetworkSubnetConfig -Name $xgLan3Subnet.Name -VirtualNetwork $vnet).Id
$xgWanNicPublicIP = New-AzureRmPublicIpAddress -ResourceGroupName $rgName -Location $location -Name $xgWanNicPublicIPName -AllocationMethod Static -DomainNameLabel $xgVmName

# Create the XG WAN network interface and assign the above public IP to it
$xgWanNic = New-AzureRmNetworkInterface -ResourceGroupName $rgName -Location $location -Name $xgWanNicName -PublicIpAddressId $xgWanNicPublicIP.Id -SubnetId $xgWanSubnetID -EnableIPForwarding

# Create the LAN network interfaces and assign them to their subnets
$xgLanNic1 = New-AzureRmNetworkInterface -ResourceGroupName $rgName -Location $location -Name $xgLan1NicName -SubnetId $xgLan1SubnetID -PrivateIpAddress $xgPrivateIPLan1 -EnableIPForwarding
$xgLanNic2 = New-AzureRmNetworkInterface -ResourceGroupName $rgName -Location $location -Name $xgLan2NicName -SubnetId $xgLan2SubnetID -PrivateIpAddress $xgPrivateIPLan2 -EnableIPForwarding
$xgLanNic3 = New-AzureRmNetworkInterface -ResourceGroupName $rgName -Location $location -Name $xgLan3NicName -SubnetId $xgLan3SubnetID -PrivateIpAddress $xgPrivateIPLan3 -EnableIPForwarding
}

### Create the Sophos XG Firewall VM Configuration and Deploy the VM
{
# Create the VM config
$xgVm = New-AzureRmVMConfig -VMName $xgVmName -VMSize $xgVmSize

# Create the credentials objects for the VM
$cred = New-Object pscredential $adminUsername, ($adminPassword | ConvertTo-SecureString -AsPlainText -Force)

# Set the operating system type to Linux and assign the credentials for the VM
$xgVm = Set-AzureRmVMOperatingSystem -VM $xgVm -Linux -ComputerName $xgVmName -Credential $cred 

# Add the WAN NIC that was previous created to the VM:
$xgVm = Add-AzureRmVMNetworkInterface -VM $xgVm -Id $xgWanNic.Id -Primary

# Add the LAN NICs that were previously created to the VM:
$xgVm = Add-AzureRmVMNetworkInterface -VM $xgVm -Id $xgLanNic1.Id
$xgVm = Add-AzureRmVMNetworkInterface -VM $xgVm -Id $xgLanNic2.Id
$xgVm = Add-AzureRmVMNetworkInterface -VM $xgVm -Id $xgLanNic3.Id

$storageAcc = Get-AzureRmStorageAccount -ResourceGroupName $rgName -Name $storageAccountName
$xgOsBlobPath = "vhds/lbazurexg1.vhd"
$xgDataBlobPath = "vhds/lbazurexg1data.vhd"
$xgOsDiskUri = $storageAcc.PrimaryEndpoints.Blob.ToString() + $xgOsBlobPath
$xgDataDiskUri = $storageAcc.PrimaryEndpoints.Blob.ToString() + $xgDataBlobPath

$xgVmOsDiskName = $xgVmName + "_OsDisk"
$xgVmDataDiskName = $xgVmName + "_DataDisk"
$xgVm.Plan = @{'name'= $xgSkuName; 'publisher'= 'sophos'; 'product' = 'sophos-xg'}
$xgVm = Set-AzureRmVMSourceImage -VM $xgVm -PublisherName "sophos" -Offer "sophos-xg" -Skus $xgSkuName -Version "latest"
$xgVm = Set-AzureRmVMOSDisk -VM $xgVm -Name $xgVmOsDiskName -VhdUri $xgOsDiskUri -Caching ReadWrite -CreateOption FromImage 
$xgVm = Add-AzureRmVMDataDisk -VM $xgVm -Name $xgVmDataDiskName -Caching ReadWrite -Lun 0 -VhdUri $xgDataDiskUri -DiskSizeInGB 100 -CreateOption FromImage

# Create the XG firewall VM
New-AzureRmVM -ResourceGroupName $rgName -Location $location -VM $xgVm
}

### Create a custom NSG for the WAN NIC of the firewall to allow all traffic
{
# Create security rules to allow access to and from the Internet on any port
$allowAllTrafficToXgInboundRule = New-AzureRmNetworkSecurityRuleConfig -Name allow_all_to_xg_inbound -Description "Allow all inbound traffic to the XG firewall WAN interface" -Access Allow -Protocol * -Direction Inbound -Priority 100 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange *
$allowAllTrafficFromXgOutboundRule = New-AzureRmNetworkSecurityRuleConfig -Name allow_all_to_xg_outbound -Description "Allow all outbound traffic from the XG firewall WAN interface" -Access Allow -Protocol * -Direction Outbound -Priority 100 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange *

# Add the rules created above to a new NSG named XgFirewallFrontEndNSG
$nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName $rgName -Location $location -Name "XgFirewallFrontEndNSG" -SecurityRules $allowAllTrafficToXgInboundRule,$allowAllTrafficFromXgOutboundRule

# Associate the NSG created above to the FrontEnd subnet
Set-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name $xgWanSubnet.Name -AddressPrefix $wanSubnetPrefix -NetworkSecurityGroup $nsg
Set-AzureRmVirtualNetwork -VirtualNetwork $vnet
}

### Create a user defined route to route all LAN traffic to the XG
{
$lan1RouteTable = New-AzureRmRouteTable -ResourceGroupName $rgName -Location $location -Name $lan1RouteTableName 
$lan2RouteTable = New-AzureRmRouteTable -ResourceGroupName $rgName -Location $location -Name $lan2RouteTableName 
$lan3RouteTable = New-AzureRmRouteTable -ResourceGroupName $rgName -Location $location -Name $lan3RouteTableName 

# Create routes and add them to the route tables:
Add-AzureRmRouteConfig -Name "route_all_to_xg_lan1" -AddressPrefix 0.0.0.0/0 -RouteTable $lan1RouteTable -NextHopType VirtualAppliance -NextHopIpAddress $xgPrivateIPLan1 | Set-AzureRmRouteTable
Add-AzureRmRouteConfig -Name "route_lan2_to_xg_lan1" -AddressPrefix $lan2SubnetPrefix -RouteTable $lan1RouteTable -NextHopType VirtualAppliance -NextHopIpAddress $xgPrivateIPLan1 | Set-AzureRmRouteTable
Add-AzureRmRouteConfig -Name "route_lan3_to_xg_lan1" -AddressPrefix $lan3SubnetPrefix -RouteTable $lan1RouteTable -NextHopType VirtualAppliance -NextHopIpAddress $xgPrivateIPLan1 | Set-AzureRmRouteTable

Add-AzureRmRouteConfig -Name "route_all_to_xg_lan2" -AddressPrefix 0.0.0.0/0 -RouteTable $lan2RouteTable -NextHopType VirtualAppliance -NextHopIpAddress $xgPrivateIPLan2 | Set-AzureRmRouteTable
Add-AzureRmRouteConfig -Name "route_lan1_to_xg_lan2" -AddressPrefix $lan1SubnetPrefix -RouteTable $lan2RouteTable -NextHopType VirtualAppliance -NextHopIpAddress $xgPrivateIPLan2 | Set-AzureRmRouteTable
Add-AzureRmRouteConfig -Name "route_lan3_to_xg_lan2" -AddressPrefix $lan3SubnetPrefix -RouteTable $lan2RouteTable -NextHopType VirtualAppliance -NextHopIpAddress $xgPrivateIPLan2 | Set-AzureRmRouteTable

Add-AzureRmRouteConfig -Name "route_all_to_xg_lan3" -AddressPrefix 0.0.0.0/0 -RouteTable $lan3RouteTable -NextHopType VirtualAppliance -NextHopIpAddress $xgPrivateIPLan3 | Set-AzureRmRouteTable
Add-AzureRmRouteConfig -Name "route_lan1_to_xg_lan3" -AddressPrefix $lan1SubnetPrefix -RouteTable $lan3RouteTable -NextHopType VirtualAppliance -NextHopIpAddress $xgPrivateIPLan3 | Set-AzureRmRouteTable
Add-AzureRmRouteConfig -Name "route_lan2_to_xg_lan3" -AddressPrefix $lan2SubnetPrefix -RouteTable $lan3RouteTable -NextHopType VirtualAppliance -NextHopIpAddress $xgPrivateIPLan3 | Set-AzureRmRouteTable

# Associate the route table with the LAN subnets
$lan1SubnetConfig = Set-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name $xgLan1Subnet.Name -AddressPrefix $lan1SubnetPrefix -RouteTable $lan1RouteTable
$lan2SubnetConfig = Set-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name $xgLan2Subnet.Name -AddressPrefix $lan2SubnetPrefix -RouteTable $lan2RouteTable
$lan3SubnetConfig = Set-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name $xgLan3Subnet.Name -AddressPrefix $lan3SubnetPrefix -RouteTable $lan3RouteTable
Set-AzureRmVirtualNetwork -VirtualNetwork $vnet
}

### Create a Windows Server into each LAN subnet
{
$srvNumber = 1..3
foreach ($number in $srvNumber)
{
$vmName = $srvNamePrefix + $number + "vm"
$nicName = $vmName + "LanNic"
$lanName = "xgLan" + $number + "Subnet"

$xgLanSubnetID = (Get-AzureRmVirtualNetworkSubnetConfig -Name $lanName -VirtualNetwork $vnet).Id
$srvNic = New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $location -SubnetId $xgLanSubnetID

$srvVm = New-AzureRmVMConfig -VMName $vmName -VMSize $srvVmSize
$srvVm = Set-AzureRmVMOperatingSystem -VM $srvVm -Windows -ComputerName $vmName -Credential $cred -ProvisionVMAgent -EnableAutoUpdate

$srvBlobPath = "vhds/" + $vmName + ".vhd"
$srvOsDiskUri = $storageAcc.PrimaryEndpoints.Blob.ToString() + $srvBlobPath
$srvDiskName = $vmName

# Define the image to use to provision the virtual machine.
$srvVm = Set-AzureRmVMSourceImage -VM $srvVm -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus Windows-Server-Technical-Preview -Version "latest"
$srvVm = Add-AzureRmVMNetworkInterface -VM $srvVm -Id $srvNic.Id
$srvVm = Set-AzureRmVMOSDisk -VM $srvVm -Name $srvDiskName -VhdUri $srvOsDiskUri -CreateOption fromImage
New-AzureRmVM -ResourceGroupName $rgName -Location $location -VM $srvVm
}

}

