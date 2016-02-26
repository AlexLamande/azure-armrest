# Azure namespace
module Azure
  module Armrest
    class BillingService < ArmrestService

      def initialize(armrest_configuration, options = {})
        super(armrest_configuration, nil, 'Microsoft.Commerce', options)
      end

      def list_rate_card(offer_durable_id, currency, locale, region_info)
        filter = build_filter(offer_durable_id, currency, locale, region_info)
        service = 'RateCard'
        url = build_url(service, filter)
        pp url
        response = rest_get(url)
        JSON.parse(response.body)
      end

      def list_usage
        service = 'UsageAggregates'
        url = build_url(service)
        pp url
        response = rest_get(url)
        JSON.parse(response.body)
      end

      def build_url(service, filter=nil)
        sub_id = armrest_configuration.subscription_id

        url =
          File.join(
            Azure::Armrest::COMMON_URI,
            sub_id,
            'providers',
            provider,
            service
          )

        url << "?api-version=#{@api_version}"
        url << "&$filter=#{filter}" unless filter.nil?

        url
      end

      def build_filter(offer_durable_id, currency, locale, region_info)
        s = "OfferDurableId eq '#{offer_durable_id}'"
        s << "and Currency eq '#{currency}'"
        s << "and Locale eq '#{locale}'"
        s << "and RegionInfo eq '#{region_info}'"

        s
      end
    end
  end
end
