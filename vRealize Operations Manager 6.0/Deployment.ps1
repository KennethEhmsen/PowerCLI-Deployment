# William Lam
# www.virtuallyghetto.com
# Deployment of vRealize Operations Manager 6.0 (vROps)

### NOTE: SSH can not be enabled because hidden properties do not seem to be implemented in Get-OvfConfiguration cmdlet ###

# Load OVF/OVA configuration into a variable
$ovffile = "Z:\Desktop\vRealize-Operations-Manager-Appliance-6.0.0.2263110_OVF10.ova"
$ovfconfig = Get-OvfConfiguration $ovffile

# vSphere Cluster + VM Network configurations
$Cluster = "Mini-Cluster"
$VMName = "vrops6"
$VMNetwork = "VM Network"

$VMHost = Get-Cluster $Cluster | Get-VMHost | Sort MemoryGB | Select -first 1
$Datastore = $VMHost | Get-datastore | Sort FreeSpaceGB -Descending | Select -first 1
$Network = Get-VirtualPortGroup -Name $VMNetwork -VMHost $vmhost

# Fill out the OVF/OVA configuration parameters

# xsmall,small,medium,large,smallrc,largerc
$ovfconfig.DeploymentOption.value = "xsmall"

# IP Address
$ovfConfig.vami.vRealize_Operations_Manager_Appliance.ip0.value = "192.168.1.150"

# Gateway
$ovfConfig.vami.vRealize_Operations_Manager_Appliance.gateway.value = "192.168.1.1"

# Netmask
$ovfConfig.vami.vRealize_Operations_Manager_Appliance.netmask0.value = "255.255.255.0"

# DNS
$ovfConfig.vami.vRealize_Operations_Manager_Appliance.DNS.value = "192.168.1.1"

# vSphere Portgroup Network Mapping
$ovfconfig.NetworkMapping.Network_1.value = $Network

# IP Protocol
$ovfconfig.IpAssignment.IpProtocol.value = "IPv4"

# Timezone
$ovfconfig.common.vamitimezone.value = "Etc/UTC"

# Deploy the OVF/OVA with the config parameters
Import-VApp -Source $ovffile -OvfConfiguration $ovfconfig -Name $VMName -VMHost $vmhost -Datastore $datastore -DiskStorageFormat thin