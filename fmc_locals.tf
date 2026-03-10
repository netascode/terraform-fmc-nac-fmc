locals {
  # Maps each domain with itself and all its parent domains
  related_domains = merge(
    {
      for domain in local.domains : domain.name => [
        for i in range(1, length(split("/", domain.name)) + 1) : join("/", slice(split("/", domain.name), 0, i))
      ]
    },
    {
      for domain in local.data_existing : domain.name => [
        for i in range(1, length(split("/", domain.name)) + 1) : join("/", slice(split("/", domain.name), 0, i))
      ]
    }
  )

  help_protocol_mapping = {
    "ICMP" = "1",
    "IGMP" = "2",
    "TCP"  = "6",
    "UDP"  = "17",
    "RDP"  = "27",
    "GRE"  = "47",
    "ESP"  = "50",
    "AH"   = "51",
  }
}
