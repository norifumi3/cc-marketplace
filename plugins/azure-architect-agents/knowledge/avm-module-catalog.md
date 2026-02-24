# AVM (Azure Verified Modules) カタログ

## 概要
Azure Verified Modules は Microsoft が公式に管理する IaC モジュール。Bicep と Terraform の両方で提供。

## レジストリ
- **Bicep**: Microsoft Container Registry (MCR) — `br/public:avm/...`
- **Terraform**: Terraform Registry — `Azure/avm-*/azurerm`

---

## Resource Modules (avm/res/)
個別の Azure リソースを管理するモジュール。

### Compute

| モジュール | Bicep Reference | 概要 |
|-----------|----------------|------|
| Virtual Machine | `br/public:avm/res/compute/virtual-machine` | VM |
| Virtual Machine Scale Set | `br/public:avm/res/compute/virtual-machine-scale-set` | VMSS |
| Managed Cluster (AKS) | `br/public:avm/res/container-service/managed-cluster` | AKS |
| Container Registry | `br/public:avm/res/container-registry/registry` | ACR |
| Container App | `br/public:avm/res/app/container-app` | Container Apps |
| Managed Environment | `br/public:avm/res/app/managed-environment` | Container Apps 環境 |
| Web Site (App Service) | `br/public:avm/res/web/site` | App Service |
| Serverfarm (App Service Plan) | `br/public:avm/res/web/serverfarm` | App Service Plan |
| Function App | `br/public:avm/res/web/site` (kind: functionapp) | Functions |
| Static Web App | `br/public:avm/res/web/static-site` | Static Web Apps |

### Networking

| モジュール | Bicep Reference | 概要 |
|-----------|----------------|------|
| Virtual Network | `br/public:avm/res/network/virtual-network` | VNet |
| Network Security Group | `br/public:avm/res/network/network-security-group` | NSG |
| Azure Firewall | `br/public:avm/res/network/azure-firewall` | Firewall |
| Application Gateway | `br/public:avm/res/network/application-gateway` | App GW |
| Front Door | `br/public:avm/res/cdn/profile` | Front Door |
| Load Balancer | `br/public:avm/res/network/load-balancer` | LB |
| Private Endpoint | `br/public:avm/res/network/private-endpoint` | PE |
| Private DNS Zone | `br/public:avm/res/network/private-dns-zone` | DNS Zone |
| VPN Gateway | `br/public:avm/res/network/vpn-gateway` | VPN GW |
| ExpressRoute Gateway | `br/public:avm/res/network/express-route-gateway` | ER GW |
| Virtual WAN | `br/public:avm/res/network/virtual-wan` | VWAN |
| Virtual Hub | `br/public:avm/res/network/virtual-hub` | VWAN Hub |
| Bastion Host | `br/public:avm/res/network/bastion-host` | Bastion |
| NAT Gateway | `br/public:avm/res/network/nat-gateway` | NAT GW |
| Route Table | `br/public:avm/res/network/route-table` | UDR |
| DNS Resolver | `br/public:avm/res/network/dns-resolver` | DNS Resolver |

### Database

| モジュール | Bicep Reference | 概要 |
|-----------|----------------|------|
| SQL Server | `br/public:avm/res/sql/server` | SQL Server |
| SQL Database | `br/public:avm/res/sql/server` (databases) | SQL DB |
| Cosmos DB Account | `br/public:avm/res/document-db/database-account` | Cosmos DB |
| PostgreSQL Flexible | `br/public:avm/res/db-for-postgre-sql/flexible-server` | PostgreSQL |
| MySQL Flexible | `br/public:avm/res/db-for-my-sql/flexible-server` | MySQL |
| Redis Cache | `br/public:avm/res/cache/redis` | Redis |

### Storage

| モジュール | Bicep Reference | 概要 |
|-----------|----------------|------|
| Storage Account | `br/public:avm/res/storage/storage-account` | Storage |

### Security & Identity

| モジュール | Bicep Reference | 概要 |
|-----------|----------------|------|
| Key Vault | `br/public:avm/res/key-vault/vault` | Key Vault |
| Managed Identity | `br/public:avm/res/managed-identity/user-assigned-identity` | Managed ID |

### Monitoring

| モジュール | Bicep Reference | 概要 |
|-----------|----------------|------|
| Log Analytics Workspace | `br/public:avm/res/operational-insights/workspace` | LAW |
| Application Insights | `br/public:avm/res/insights/component` | App Insights |
| Action Group | `br/public:avm/res/insights/action-group` | Action Group |

### AI

| モジュール | Bicep Reference | 概要 |
|-----------|----------------|------|
| Cognitive Services Account | `br/public:avm/res/cognitive-services/account` | AI Services |
| AI Search | `br/public:avm/res/search/search-service` | AI Search |
| Machine Learning Workspace | `br/public:avm/res/machine-learning-services/workspace` | ML Workspace |

### Management

| モジュール | Bicep Reference | 概要 |
|-----------|----------------|------|
| Resource Group | `br/public:avm/res/resources/resource-group` | RG |
| Management Group | `br/public:avm/res/management/management-group` | MG |
| Policy Assignment | `br/public:avm/res/authorization/policy-assignment` | Policy |
| Role Assignment | `br/public:avm/res/authorization/role-assignment` | RBAC |

### Integration

| モジュール | Bicep Reference | 概要 |
|-----------|----------------|------|
| Service Bus Namespace | `br/public:avm/res/service-bus/namespace` | Service Bus |
| Event Hub Namespace | `br/public:avm/res/event-hub/namespace` | Event Hubs |
| Event Grid Topic | `br/public:avm/res/event-grid/topic` | Event Grid |
| API Management | `br/public:avm/res/api-management/service` | APIM |

---

## Pattern Modules (avm/ptn/)
複数リソースを組み合わせたパターンモジュール。

| モジュール | Bicep Reference | 概要 |
|-----------|----------------|------|
| Subscription Vending | `br/public:avm/ptn/lz/sub-vending` | サブスクリプション作成 |
| ACA LZA Hosting | `br/public:avm/ptn/aca-lza/hosting-environment` | Container Apps LZA |
| Virtual Network Gateway | `br/public:avm/ptn/network/virtual-network-gateway` | VPN/ER GW |
| Hub Networking | `br/public:avm/ptn/network/hub-networking` | Hub ネットワーク |
| Private Link Private DNS Zone | `br/public:avm/ptn/network/private-link-private-dns-zones` | PL DNS |

---

## ALZ コンポーネントと AVM のマッピング

| ALZ コンポーネント | AVM Module |
|------------------|-----------|
| 管理グループ階層 | `avm/res/management/management-group` |
| サブスクリプション作成 | `avm/ptn/lz/sub-vending` |
| Hub VNet | `avm/res/network/virtual-network` + `avm/ptn/network/hub-networking` |
| Azure Firewall | `avm/res/network/azure-firewall` |
| VPN Gateway | `avm/ptn/network/virtual-network-gateway` |
| Log Analytics | `avm/res/operational-insights/workspace` |
| Policy Assignment | `avm/res/authorization/policy-assignment` |
| Key Vault | `avm/res/key-vault/vault` |

---

## 使用例

### Bicep
```bicep
// AVM Resource Module の使用例
module vnet 'br/public:avm/res/network/virtual-network:0.5.0' = {
  name: 'vnet-deployment'
  params: {
    name: 'vnet-hub-prod-japaneast-001'
    location: 'japaneast'
    addressPrefixes: ['10.0.0.0/16']
    subnets: [
      {
        name: 'AzureFirewallSubnet'
        addressPrefix: '10.0.0.0/24'
      }
      {
        name: 'GatewaySubnet'
        addressPrefix: '10.0.1.0/24'
      }
    ]
    tags: {
      Environment: 'prod'
      CostCenter: 'CC-12345'
    }
  }
}
```

### Terraform
```hcl
# AVM Resource Module の使用例
module "virtual_network" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "~> 0.5.0"

  name                = "vnet-hub-prod-japaneast-001"
  resource_group_name = azurerm_resource_group.hub.name
  location            = "japaneast"
  address_space       = ["10.0.0.0/16"]

  subnets = {
    AzureFirewallSubnet = {
      address_prefix = "10.0.0.0/24"
    }
    GatewaySubnet = {
      address_prefix = "10.0.1.0/24"
    }
  }

  tags = {
    Environment = "prod"
    CostCenter  = "CC-12345"
  }
}
```
