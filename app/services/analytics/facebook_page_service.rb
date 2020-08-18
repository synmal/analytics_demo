class Analytics::FacebookPageService
  LIFETIME_INSIGHTS = [
    'post_engaged_users',
    'post_negative_feedback',
    'post_negative_feedback_unique',
    # 'post_negative_feedback_by_type_unique',
    'post_clicks',
    'post_clicks_unique',
    'post_engaged_fan',
    # 'post_clicks_by_type',
    # 'post_clicks_by_type_unique',
    'post_impressions',
    'post_impressions_unique',
    'post_impressions_paid',
    'post_impressions_paid_unique',
    'post_impressions_fan',
    'post_impressions_fan_unique',
    'post_impressions_fan_paid',
    'post_impressions_fan_paid_unique',
    'post_impressions_organic',
    'post_impressions_organic_unique',
    'post_impressions_viral',
    'post_impressions_viral_unique',
    'post_impressions_nonviral',
    'post_impressions_nonviral_unique',
    # 'post_impressions_by_story_type',
    # 'post_impressions_by_story_type_unique',
    # 'post_reactions_by_type_total'
  ]

  class << self
    def get_posts
      fields = "posts{id,permalink_url,message,attachments{media_type,target},insights.metric(#{LIFETIME_INSIGHTS.join(',')}){name, values}},videos{id,video_insights{name,values}}"
      # response = call(fields)
      # parse_response(response)
      initial_data = parse_response(dummy_data)
      arrange_data(initial_data)
    end

    private
    def call(fields = '')
      Faraday.get("https://graph.facebook.com/v7.0/#{Rails.application.credentials.fb_page[:id]}") do |req|
        req.params['access_token'] = Rails.application.credentials.fb_page[:page_access_token]
        req.params['fields'] = fields
      end
    end

    def parse_response(response)
      # JSON.parse(response.body, symbolize_names: true)
      JSON.parse(response, symbolize_names: true)
    end

    def arrange_data(data)
      posts = data.dig(:posts, :data)
      videos = data.dig(:videos, :data)

      posts.map do |ps|
        ps.dig(:attachments, :data)&.map do |att|
          if att[:media_type] == 'video'
            video_id = att.dig(:target, :id)
            video = videos.find{|vd| vd[:id]}
            att.merge!(video_insights: video[:video_insights])
          else
            att
          end
        end

        ps
      end
    end

    def dummy_data
      {
        "posts": {
          "data": [
            {
              "id": "109726977412856_155874559464764",
              "permalink_url": "https://www.facebook.com/109726977412856/posts/155874559464764/",
              "message": "Test video",
              "attachments": {
                "data": [
                  {
                    "media_type": "video",
                    "target": {
                      "id": "755568755205096",
                      "url": "https://www.facebook.com/109726977412856/videos/755568755205096/"
                    }
                  }
                ]
              },
              "insights": {
                "data": [
                  {
                    "name": "post_engaged_users",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_155874559464764/insights/post_engaged_users/lifetime"
                  },
                  {
                    "name": "post_negative_feedback",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_155874559464764/insights/post_negative_feedback/lifetime"
                  },
                  {
                    "name": "post_negative_feedback_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_155874559464764/insights/post_negative_feedback_unique/lifetime"
                  },
                  {
                    "name": "post_clicks",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_155874559464764/insights/post_clicks/lifetime"
                  },
                  {
                    "name": "post_clicks_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_155874559464764/insights/post_clicks_unique/lifetime"
                  },
                  {
                    "name": "post_engaged_fan",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_155874559464764/insights/post_engaged_fan/lifetime"
                  },
                  {
                    "name": "post_impressions",
                    "values": [
                      {
                        "value": 1
                      }
                    ],
                    "id": "109726977412856_155874559464764/insights/post_impressions/lifetime"
                  },
                  {
                    "name": "post_impressions_unique",
                    "values": [
                      {
                        "value": 1
                      }
                    ],
                    "id": "109726977412856_155874559464764/insights/post_impressions_unique/lifetime"
                  },
                  {
                    "name": "post_impressions_paid",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_155874559464764/insights/post_impressions_paid/lifetime"
                  },
                  {
                    "name": "post_impressions_paid_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_155874559464764/insights/post_impressions_paid_unique/lifetime"
                  },
                  {
                    "name": "post_impressions_fan",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_155874559464764/insights/post_impressions_fan/lifetime"
                  },
                  {
                    "name": "post_impressions_fan_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_155874559464764/insights/post_impressions_fan_unique/lifetime"
                  },
                  {
                    "name": "post_impressions_fan_paid",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_155874559464764/insights/post_impressions_fan_paid/lifetime"
                  },
                  {
                    "name": "post_impressions_fan_paid_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_155874559464764/insights/post_impressions_fan_paid_unique/lifetime"
                  },
                  {
                    "name": "post_impressions_organic",
                    "values": [
                      {
                        "value": 1
                      }
                    ],
                    "id": "109726977412856_155874559464764/insights/post_impressions_organic/lifetime"
                  },
                  {
                    "name": "post_impressions_organic_unique",
                    "values": [
                      {
                        "value": 1
                      }
                    ],
                    "id": "109726977412856_155874559464764/insights/post_impressions_organic_unique/lifetime"
                  },
                  {
                    "name": "post_impressions_viral",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_155874559464764/insights/post_impressions_viral/lifetime"
                  },
                  {
                    "name": "post_impressions_viral_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_155874559464764/insights/post_impressions_viral_unique/lifetime"
                  },
                  {
                    "name": "post_impressions_nonviral",
                    "values": [
                      {
                        "value": 1
                      }
                    ],
                    "id": "109726977412856_155874559464764/insights/post_impressions_nonviral/lifetime"
                  },
                  {
                    "name": "post_impressions_nonviral_unique",
                    "values": [
                      {
                        "value": 1
                      }
                    ],
                    "id": "109726977412856_155874559464764/insights/post_impressions_nonviral_unique/lifetime"
                  }
                ],
                "paging": {
                  "previous": "https://graph.facebook.com/v7.0/109726977412856_155874559464764/insights?access_token=EAAsjz6AuZBbEBAJH9nt4fswMs9rBe9r7GO9XAKA8Iwz8i5nDxZBWwiqGAkzHdeOTSnzxjhi53aqWdAkgrZBWXWOz76wng3W6Ic52z8brJ5Mz9ZB5hBGZB75CHnDb1sTnXq7Rm8GKRRx48ERBJZCBpaHV2ZB1qflWtXxxujHV8iSZBJUhnE1AUn6RqfnjokbowLsZD&fields=name%2C+values&metric=post_engaged_users%2Cpost_negative_feedback%2Cpost_negative_feedback_unique%2Cpost_clicks%2Cpost_clicks_unique%2Cpost_engaged_fan%2Cpost_impressions%2Cpost_impressions_unique%2Cpost_impressions_paid%2Cpost_impressions_paid_unique%2Cpost_impressions_fan%2Cpost_impressions_fan_unique%2Cpost_impressions_fan_paid%2Cpost_impressions_fan_paid_unique%2Cpost_impressions_organic%2Cpost_impressions_organic_unique%2Cpost_impressions_viral%2Cpost_impressions_viral_unique%2Cpost_impressions_nonviral%2Cpost_impressions_nonviral_unique&since=1597215600&until=1597388400",
                  "next": "https://graph.facebook.com/v7.0/109726977412856_155874559464764/insights?access_token=EAAsjz6AuZBbEBAJH9nt4fswMs9rBe9r7GO9XAKA8Iwz8i5nDxZBWwiqGAkzHdeOTSnzxjhi53aqWdAkgrZBWXWOz76wng3W6Ic52z8brJ5Mz9ZB5hBGZB75CHnDb1sTnXq7Rm8GKRRx48ERBJZCBpaHV2ZB1qflWtXxxujHV8iSZBJUhnE1AUn6RqfnjokbowLsZD&fields=name%2C+values&metric=post_engaged_users%2Cpost_negative_feedback%2Cpost_negative_feedback_unique%2Cpost_clicks%2Cpost_clicks_unique%2Cpost_engaged_fan%2Cpost_impressions%2Cpost_impressions_unique%2Cpost_impressions_paid%2Cpost_impressions_paid_unique%2Cpost_impressions_fan%2Cpost_impressions_fan_unique%2Cpost_impressions_fan_paid%2Cpost_impressions_fan_paid_unique%2Cpost_impressions_organic%2Cpost_impressions_organic_unique%2Cpost_impressions_viral%2Cpost_impressions_viral_unique%2Cpost_impressions_nonviral%2Cpost_impressions_nonviral_unique&since=1597561200&until=1597734000"
                }
              }
            },
            {
              "id": "109726977412856_153221506396736",
              "permalink_url": "https://www.facebook.com/109726977412856/posts/153221506396736/",
              "attachments": {
                "data": [
                  {
                    "media_type": "photo",
                    "target": {
                      "id": "153221466396740",
                      "url": "https://www.facebook.com/109726977412856/photos/a.153221496396737/153221466396740/?type=3"
                    }
                  }
                ]
              },
              "insights": {
                "data": [
                  {
                    "name": "post_engaged_users",
                    "values": [
                      {
                        "value": 1
                      }
                    ],
                    "id": "109726977412856_153221506396736/insights/post_engaged_users/lifetime"
                  },
                  {
                    "name": "post_negative_feedback",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153221506396736/insights/post_negative_feedback/lifetime"
                  },
                  {
                    "name": "post_negative_feedback_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153221506396736/insights/post_negative_feedback_unique/lifetime"
                  },
                  {
                    "name": "post_clicks",
                    "values": [
                      {
                        "value": 1
                      }
                    ],
                    "id": "109726977412856_153221506396736/insights/post_clicks/lifetime"
                  },
                  {
                    "name": "post_clicks_unique",
                    "values": [
                      {
                        "value": 1
                      }
                    ],
                    "id": "109726977412856_153221506396736/insights/post_clicks_unique/lifetime"
                  },
                  {
                    "name": "post_engaged_fan",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153221506396736/insights/post_engaged_fan/lifetime"
                  },
                  {
                    "name": "post_impressions",
                    "values": [
                      {
                        "value": 2
                      }
                    ],
                    "id": "109726977412856_153221506396736/insights/post_impressions/lifetime"
                  },
                  {
                    "name": "post_impressions_unique",
                    "values": [
                      {
                        "value": 1
                      }
                    ],
                    "id": "109726977412856_153221506396736/insights/post_impressions_unique/lifetime"
                  },
                  {
                    "name": "post_impressions_paid",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153221506396736/insights/post_impressions_paid/lifetime"
                  },
                  {
                    "name": "post_impressions_paid_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153221506396736/insights/post_impressions_paid_unique/lifetime"
                  },
                  {
                    "name": "post_impressions_fan",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153221506396736/insights/post_impressions_fan/lifetime"
                  },
                  {
                    "name": "post_impressions_fan_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153221506396736/insights/post_impressions_fan_unique/lifetime"
                  },
                  {
                    "name": "post_impressions_fan_paid",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153221506396736/insights/post_impressions_fan_paid/lifetime"
                  },
                  {
                    "name": "post_impressions_fan_paid_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153221506396736/insights/post_impressions_fan_paid_unique/lifetime"
                  },
                  {
                    "name": "post_impressions_organic",
                    "values": [
                      {
                        "value": 2
                      }
                    ],
                    "id": "109726977412856_153221506396736/insights/post_impressions_organic/lifetime"
                  },
                  {
                    "name": "post_impressions_organic_unique",
                    "values": [
                      {
                        "value": 1
                      }
                    ],
                    "id": "109726977412856_153221506396736/insights/post_impressions_organic_unique/lifetime"
                  },
                  {
                    "name": "post_impressions_viral",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153221506396736/insights/post_impressions_viral/lifetime"
                  },
                  {
                    "name": "post_impressions_viral_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153221506396736/insights/post_impressions_viral_unique/lifetime"
                  },
                  {
                    "name": "post_impressions_nonviral",
                    "values": [
                      {
                        "value": 2
                      }
                    ],
                    "id": "109726977412856_153221506396736/insights/post_impressions_nonviral/lifetime"
                  },
                  {
                    "name": "post_impressions_nonviral_unique",
                    "values": [
                      {
                        "value": 1
                      }
                    ],
                    "id": "109726977412856_153221506396736/insights/post_impressions_nonviral_unique/lifetime"
                  }
                ],
                "paging": {
                  "previous": "https://graph.facebook.com/v7.0/109726977412856_153221506396736/insights?access_token=EAAsjz6AuZBbEBAJH9nt4fswMs9rBe9r7GO9XAKA8Iwz8i5nDxZBWwiqGAkzHdeOTSnzxjhi53aqWdAkgrZBWXWOz76wng3W6Ic52z8brJ5Mz9ZB5hBGZB75CHnDb1sTnXq7Rm8GKRRx48ERBJZCBpaHV2ZB1qflWtXxxujHV8iSZBJUhnE1AUn6RqfnjokbowLsZD&fields=name%2C+values&metric=post_engaged_users%2Cpost_negative_feedback%2Cpost_negative_feedback_unique%2Cpost_clicks%2Cpost_clicks_unique%2Cpost_engaged_fan%2Cpost_impressions%2Cpost_impressions_unique%2Cpost_impressions_paid%2Cpost_impressions_paid_unique%2Cpost_impressions_fan%2Cpost_impressions_fan_unique%2Cpost_impressions_fan_paid%2Cpost_impressions_fan_paid_unique%2Cpost_impressions_organic%2Cpost_impressions_organic_unique%2Cpost_impressions_viral%2Cpost_impressions_viral_unique%2Cpost_impressions_nonviral%2Cpost_impressions_nonviral_unique&since=1597215600&until=1597388400",
                  "next": "https://graph.facebook.com/v7.0/109726977412856_153221506396736/insights?access_token=EAAsjz6AuZBbEBAJH9nt4fswMs9rBe9r7GO9XAKA8Iwz8i5nDxZBWwiqGAkzHdeOTSnzxjhi53aqWdAkgrZBWXWOz76wng3W6Ic52z8brJ5Mz9ZB5hBGZB75CHnDb1sTnXq7Rm8GKRRx48ERBJZCBpaHV2ZB1qflWtXxxujHV8iSZBJUhnE1AUn6RqfnjokbowLsZD&fields=name%2C+values&metric=post_engaged_users%2Cpost_negative_feedback%2Cpost_negative_feedback_unique%2Cpost_clicks%2Cpost_clicks_unique%2Cpost_engaged_fan%2Cpost_impressions%2Cpost_impressions_unique%2Cpost_impressions_paid%2Cpost_impressions_paid_unique%2Cpost_impressions_fan%2Cpost_impressions_fan_unique%2Cpost_impressions_fan_paid%2Cpost_impressions_fan_paid_unique%2Cpost_impressions_organic%2Cpost_impressions_organic_unique%2Cpost_impressions_viral%2Cpost_impressions_viral_unique%2Cpost_impressions_nonviral%2Cpost_impressions_nonviral_unique&since=1597561200&until=1597734000"
                }
              }
            },
            {
              "id": "109726977412856_153220469730173",
              "permalink_url": "https://www.facebook.com/109726977412856/posts/153220469730173/",
              "message": "Test testTTTT",
              "insights": {
                "data": [
                  {
                    "name": "post_engaged_users",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153220469730173/insights/post_engaged_users/lifetime"
                  },
                  {
                    "name": "post_negative_feedback",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153220469730173/insights/post_negative_feedback/lifetime"
                  },
                  {
                    "name": "post_negative_feedback_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153220469730173/insights/post_negative_feedback_unique/lifetime"
                  },
                  {
                    "name": "post_clicks",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153220469730173/insights/post_clicks/lifetime"
                  },
                  {
                    "name": "post_clicks_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153220469730173/insights/post_clicks_unique/lifetime"
                  },
                  {
                    "name": "post_engaged_fan",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153220469730173/insights/post_engaged_fan/lifetime"
                  },
                  {
                    "name": "post_impressions",
                    "values": [
                      {
                        "value": 2
                      }
                    ],
                    "id": "109726977412856_153220469730173/insights/post_impressions/lifetime"
                  },
                  {
                    "name": "post_impressions_unique",
                    "values": [
                      {
                        "value": 1
                      }
                    ],
                    "id": "109726977412856_153220469730173/insights/post_impressions_unique/lifetime"
                  },
                  {
                    "name": "post_impressions_paid",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153220469730173/insights/post_impressions_paid/lifetime"
                  },
                  {
                    "name": "post_impressions_paid_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153220469730173/insights/post_impressions_paid_unique/lifetime"
                  },
                  {
                    "name": "post_impressions_fan",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153220469730173/insights/post_impressions_fan/lifetime"
                  },
                  {
                    "name": "post_impressions_fan_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153220469730173/insights/post_impressions_fan_unique/lifetime"
                  },
                  {
                    "name": "post_impressions_fan_paid",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153220469730173/insights/post_impressions_fan_paid/lifetime"
                  },
                  {
                    "name": "post_impressions_fan_paid_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153220469730173/insights/post_impressions_fan_paid_unique/lifetime"
                  },
                  {
                    "name": "post_impressions_organic",
                    "values": [
                      {
                        "value": 2
                      }
                    ],
                    "id": "109726977412856_153220469730173/insights/post_impressions_organic/lifetime"
                  },
                  {
                    "name": "post_impressions_organic_unique",
                    "values": [
                      {
                        "value": 1
                      }
                    ],
                    "id": "109726977412856_153220469730173/insights/post_impressions_organic_unique/lifetime"
                  },
                  {
                    "name": "post_impressions_viral",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153220469730173/insights/post_impressions_viral/lifetime"
                  },
                  {
                    "name": "post_impressions_viral_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153220469730173/insights/post_impressions_viral_unique/lifetime"
                  },
                  {
                    "name": "post_impressions_nonviral",
                    "values": [
                      {
                        "value": 2
                      }
                    ],
                    "id": "109726977412856_153220469730173/insights/post_impressions_nonviral/lifetime"
                  },
                  {
                    "name": "post_impressions_nonviral_unique",
                    "values": [
                      {
                        "value": 1
                      }
                    ],
                    "id": "109726977412856_153220469730173/insights/post_impressions_nonviral_unique/lifetime"
                  }
                ],
                "paging": {
                  "previous": "https://graph.facebook.com/v7.0/109726977412856_153220469730173/insights?access_token=EAAsjz6AuZBbEBAJH9nt4fswMs9rBe9r7GO9XAKA8Iwz8i5nDxZBWwiqGAkzHdeOTSnzxjhi53aqWdAkgrZBWXWOz76wng3W6Ic52z8brJ5Mz9ZB5hBGZB75CHnDb1sTnXq7Rm8GKRRx48ERBJZCBpaHV2ZB1qflWtXxxujHV8iSZBJUhnE1AUn6RqfnjokbowLsZD&fields=name%2C+values&metric=post_engaged_users%2Cpost_negative_feedback%2Cpost_negative_feedback_unique%2Cpost_clicks%2Cpost_clicks_unique%2Cpost_engaged_fan%2Cpost_impressions%2Cpost_impressions_unique%2Cpost_impressions_paid%2Cpost_impressions_paid_unique%2Cpost_impressions_fan%2Cpost_impressions_fan_unique%2Cpost_impressions_fan_paid%2Cpost_impressions_fan_paid_unique%2Cpost_impressions_organic%2Cpost_impressions_organic_unique%2Cpost_impressions_viral%2Cpost_impressions_viral_unique%2Cpost_impressions_nonviral%2Cpost_impressions_nonviral_unique&since=1597215600&until=1597388400",
                  "next": "https://graph.facebook.com/v7.0/109726977412856_153220469730173/insights?access_token=EAAsjz6AuZBbEBAJH9nt4fswMs9rBe9r7GO9XAKA8Iwz8i5nDxZBWwiqGAkzHdeOTSnzxjhi53aqWdAkgrZBWXWOz76wng3W6Ic52z8brJ5Mz9ZB5hBGZB75CHnDb1sTnXq7Rm8GKRRx48ERBJZCBpaHV2ZB1qflWtXxxujHV8iSZBJUhnE1AUn6RqfnjokbowLsZD&fields=name%2C+values&metric=post_engaged_users%2Cpost_negative_feedback%2Cpost_negative_feedback_unique%2Cpost_clicks%2Cpost_clicks_unique%2Cpost_engaged_fan%2Cpost_impressions%2Cpost_impressions_unique%2Cpost_impressions_paid%2Cpost_impressions_paid_unique%2Cpost_impressions_fan%2Cpost_impressions_fan_unique%2Cpost_impressions_fan_paid%2Cpost_impressions_fan_paid_unique%2Cpost_impressions_organic%2Cpost_impressions_organic_unique%2Cpost_impressions_viral%2Cpost_impressions_viral_unique%2Cpost_impressions_nonviral%2Cpost_impressions_nonviral_unique&since=1597561200&until=1597734000"
                }
              }
            },
            {
              "id": "109726977412856_153207216398165",
              "permalink_url": "https://www.facebook.com/109726977412856/posts/153207216398165/",
              "message": "TESTTTT",
              "insights": {
                "data": [
                  {
                    "name": "post_engaged_users",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153207216398165/insights/post_engaged_users/lifetime"
                  },
                  {
                    "name": "post_negative_feedback",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153207216398165/insights/post_negative_feedback/lifetime"
                  },
                  {
                    "name": "post_negative_feedback_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153207216398165/insights/post_negative_feedback_unique/lifetime"
                  },
                  {
                    "name": "post_clicks",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153207216398165/insights/post_clicks/lifetime"
                  },
                  {
                    "name": "post_clicks_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153207216398165/insights/post_clicks_unique/lifetime"
                  },
                  {
                    "name": "post_engaged_fan",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153207216398165/insights/post_engaged_fan/lifetime"
                  },
                  {
                    "name": "post_impressions",
                    "values": [
                      {
                        "value": 2
                      }
                    ],
                    "id": "109726977412856_153207216398165/insights/post_impressions/lifetime"
                  },
                  {
                    "name": "post_impressions_unique",
                    "values": [
                      {
                        "value": 1
                      }
                    ],
                    "id": "109726977412856_153207216398165/insights/post_impressions_unique/lifetime"
                  },
                  {
                    "name": "post_impressions_paid",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153207216398165/insights/post_impressions_paid/lifetime"
                  },
                  {
                    "name": "post_impressions_paid_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153207216398165/insights/post_impressions_paid_unique/lifetime"
                  },
                  {
                    "name": "post_impressions_fan",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153207216398165/insights/post_impressions_fan/lifetime"
                  },
                  {
                    "name": "post_impressions_fan_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153207216398165/insights/post_impressions_fan_unique/lifetime"
                  },
                  {
                    "name": "post_impressions_fan_paid",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153207216398165/insights/post_impressions_fan_paid/lifetime"
                  },
                  {
                    "name": "post_impressions_fan_paid_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153207216398165/insights/post_impressions_fan_paid_unique/lifetime"
                  },
                  {
                    "name": "post_impressions_organic",
                    "values": [
                      {
                        "value": 2
                      }
                    ],
                    "id": "109726977412856_153207216398165/insights/post_impressions_organic/lifetime"
                  },
                  {
                    "name": "post_impressions_organic_unique",
                    "values": [
                      {
                        "value": 1
                      }
                    ],
                    "id": "109726977412856_153207216398165/insights/post_impressions_organic_unique/lifetime"
                  },
                  {
                    "name": "post_impressions_viral",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153207216398165/insights/post_impressions_viral/lifetime"
                  },
                  {
                    "name": "post_impressions_viral_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153207216398165/insights/post_impressions_viral_unique/lifetime"
                  },
                  {
                    "name": "post_impressions_nonviral",
                    "values": [
                      {
                        "value": 2
                      }
                    ],
                    "id": "109726977412856_153207216398165/insights/post_impressions_nonviral/lifetime"
                  },
                  {
                    "name": "post_impressions_nonviral_unique",
                    "values": [
                      {
                        "value": 1
                      }
                    ],
                    "id": "109726977412856_153207216398165/insights/post_impressions_nonviral_unique/lifetime"
                  }
                ],
                "paging": {
                  "previous": "https://graph.facebook.com/v7.0/109726977412856_153207216398165/insights?access_token=EAAsjz6AuZBbEBAJH9nt4fswMs9rBe9r7GO9XAKA8Iwz8i5nDxZBWwiqGAkzHdeOTSnzxjhi53aqWdAkgrZBWXWOz76wng3W6Ic52z8brJ5Mz9ZB5hBGZB75CHnDb1sTnXq7Rm8GKRRx48ERBJZCBpaHV2ZB1qflWtXxxujHV8iSZBJUhnE1AUn6RqfnjokbowLsZD&fields=name%2C+values&metric=post_engaged_users%2Cpost_negative_feedback%2Cpost_negative_feedback_unique%2Cpost_clicks%2Cpost_clicks_unique%2Cpost_engaged_fan%2Cpost_impressions%2Cpost_impressions_unique%2Cpost_impressions_paid%2Cpost_impressions_paid_unique%2Cpost_impressions_fan%2Cpost_impressions_fan_unique%2Cpost_impressions_fan_paid%2Cpost_impressions_fan_paid_unique%2Cpost_impressions_organic%2Cpost_impressions_organic_unique%2Cpost_impressions_viral%2Cpost_impressions_viral_unique%2Cpost_impressions_nonviral%2Cpost_impressions_nonviral_unique&since=1597215600&until=1597388400",
                  "next": "https://graph.facebook.com/v7.0/109726977412856_153207216398165/insights?access_token=EAAsjz6AuZBbEBAJH9nt4fswMs9rBe9r7GO9XAKA8Iwz8i5nDxZBWwiqGAkzHdeOTSnzxjhi53aqWdAkgrZBWXWOz76wng3W6Ic52z8brJ5Mz9ZB5hBGZB75CHnDb1sTnXq7Rm8GKRRx48ERBJZCBpaHV2ZB1qflWtXxxujHV8iSZBJUhnE1AUn6RqfnjokbowLsZD&fields=name%2C+values&metric=post_engaged_users%2Cpost_negative_feedback%2Cpost_negative_feedback_unique%2Cpost_clicks%2Cpost_clicks_unique%2Cpost_engaged_fan%2Cpost_impressions%2Cpost_impressions_unique%2Cpost_impressions_paid%2Cpost_impressions_paid_unique%2Cpost_impressions_fan%2Cpost_impressions_fan_unique%2Cpost_impressions_fan_paid%2Cpost_impressions_fan_paid_unique%2Cpost_impressions_organic%2Cpost_impressions_organic_unique%2Cpost_impressions_viral%2Cpost_impressions_viral_unique%2Cpost_impressions_nonviral%2Cpost_impressions_nonviral_unique&since=1597561200&until=1597734000"
                }
              }
            }
          ],
          "paging": {
            "cursors": {
              "before": "QVFIUm8tVGVfQjlOYVExazRMdm5LVGk1d3p5V2drUlltNDIwQmtIUE1vTWFBY3c5V2FaaW1wTVlVMTVxSE5jWWptRDd4SlVMMFIydnVuV1lUcThyMEtOWHhvdjNZAUC1HaHMwZA0lqbVJ4NFFvRmlpSTNEV2pELXA4V1I2Ni1vajliZAnU4",
              "after": "QVFIUlJQckNfcklKUDlUbm9sZAXpGZAGZAsT09ERGFzd09LbWpwNHlWazNOVDFhRE9fZA19LU2dQRVViSjJWN2VZAcjh3RXBMRFFrTlZA3cU5qVWFLeHdvRlJKaTJybmg3UnlnUi1zZAzJNWXdjOWhScWJMT1lWa2t6UElHZAEI3bVNHOXQ2VV9j"
            }
          }
        },
        "videos": {
          "data": [
            {
              "id": "755568755205096",
              "video_insights": {
                "data": [
                  {
                    "name": "total_video_views",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_views/lifetime"
                  },
                  {
                    "name": "total_video_views_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_views_unique/lifetime"
                  },
                  {
                    "name": "total_video_views_autoplayed",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_views_autoplayed/lifetime"
                  },
                  {
                    "name": "total_video_views_clicked_to_play",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_views_clicked_to_play/lifetime"
                  },
                  {
                    "name": "total_video_views_organic",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_views_organic/lifetime"
                  },
                  {
                    "name": "total_video_views_organic_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_views_organic_unique/lifetime"
                  },
                  {
                    "name": "total_video_views_paid",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_views_paid/lifetime"
                  },
                  {
                    "name": "total_video_views_paid_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_views_paid_unique/lifetime"
                  },
                  {
                    "name": "total_video_views_sound_on",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_views_sound_on/lifetime"
                  },
                  {
                    "name": "total_video_views_by_distribution_type",
                    "values": [
                      {
                        "value": {}
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_views_by_distribution_type/lifetime"
                  },
                  {
                    "name": "total_video_view_time_by_distribution_type",
                    "values": [
                      {
                        "value": {}
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_view_time_by_distribution_type/lifetime"
                  },
                  {
                    "name": "total_video_view_time_by_country_id",
                    "values": [
                      {
                        "value": {}
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_view_time_by_country_id/lifetime"
                  },
                  {
                    "name": "total_video_view_time_by_region_id",
                    "values": [
                      {
                        "value": {}
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_view_time_by_region_id/lifetime"
                  },
                  {
                    "name": "total_video_view_time_by_age_bucket_and_gender",
                    "values": [
                      {
                        "value": {}
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_view_time_by_age_bucket_and_gender/lifetime"
                  },
                  {
                    "name": "total_video_play_count",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_play_count/lifetime"
                  },
                  {
                    "name": "total_video_consumption_rate",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_consumption_rate/lifetime"
                  },
                  {
                    "name": "total_video_complete_views",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_complete_views/lifetime"
                  },
                  {
                    "name": "total_video_complete_views_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_complete_views_unique/lifetime"
                  },
                  {
                    "name": "total_video_complete_views_auto_played",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_complete_views_auto_played/lifetime"
                  },
                  {
                    "name": "total_video_complete_views_clicked_to_play",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_complete_views_clicked_to_play/lifetime"
                  },
                  {
                    "name": "total_video_complete_views_organic",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_complete_views_organic/lifetime"
                  },
                  {
                    "name": "total_video_complete_views_organic_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_complete_views_organic_unique/lifetime"
                  },
                  {
                    "name": "total_video_complete_views_paid",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_complete_views_paid/lifetime"
                  },
                  {
                    "name": "total_video_complete_views_paid_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_complete_views_paid_unique/lifetime"
                  },
                  {
                    "name": "video_asset_60s_video_view_total_count_by_is_monetizable",
                    "values": [
                      {
                        "value": {}
                      }
                    ],
                    "id": "755568755205096/video_insights/video_asset_60s_video_view_total_count_by_is_monetizable/lifetime"
                  },
                  {
                    "name": "total_video_15min_excludes_shorter_views",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_15min_excludes_shorter_views/lifetime"
                  },
                  {
                    "name": "total_video_15min_excludes_shorter_views_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_15min_excludes_shorter_views_unique/lifetime"
                  },
                  {
                    "name": "total_video_30s_views",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_30s_views/lifetime"
                  },
                  {
                    "name": "total_video_30s_views_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_30s_views_unique/lifetime"
                  },
                  {
                    "name": "total_video_30s_views_auto_played",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_30s_views_auto_played/lifetime"
                  },
                  {
                    "name": "total_video_30s_views_clicked_to_play",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_30s_views_clicked_to_play/lifetime"
                  },
                  {
                    "name": "total_video_30s_views_organic",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_30s_views_organic/lifetime"
                  },
                  {
                    "name": "total_video_30s_views_paid",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_30s_views_paid/lifetime"
                  },
                  {
                    "name": "total_video_10s_views",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_10s_views/lifetime"
                  },
                  {
                    "name": "total_video_10s_views_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_10s_views_unique/lifetime"
                  },
                  {
                    "name": "total_video_10s_views_auto_played",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_10s_views_auto_played/lifetime"
                  },
                  {
                    "name": "total_video_10s_views_clicked_to_play",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_10s_views_clicked_to_play/lifetime"
                  },
                  {
                    "name": "total_video_10s_views_organic",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_10s_views_organic/lifetime"
                  },
                  {
                    "name": "total_video_10s_views_paid",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_10s_views_paid/lifetime"
                  },
                  {
                    "name": "total_video_10s_views_sound_on",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_10s_views_sound_on/lifetime"
                  },
                  {
                    "name": "total_video_retention_graph",
                    "values": [
                      {
                        "value": {}
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_retention_graph/lifetime"
                  },
                  {
                    "name": "total_video_retention_graph_autoplayed",
                    "values": [
                      {
                        "value": {}
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_retention_graph_autoplayed/lifetime"
                  },
                  {
                    "name": "total_video_retention_graph_clicked_to_play",
                    "values": [
                      {
                        "value": {}
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_retention_graph_clicked_to_play/lifetime"
                  },
                  {
                    "name": "total_video_retention_graph_gender_male",
                    "values": [
                      {
                        "value": {}
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_retention_graph_gender_male/lifetime"
                  },
                  {
                    "name": "total_video_retention_graph_gender_female",
                    "values": [
                      {
                        "value": {}
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_retention_graph_gender_female/lifetime"
                  },
                  {
                    "name": "total_video_avg_time_watched",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_avg_time_watched/lifetime"
                  },
                  {
                    "name": "total_video_view_total_time",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_view_total_time/lifetime"
                  },
                  {
                    "name": "total_video_view_total_time_organic",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_view_total_time_organic/lifetime"
                  },
                  {
                    "name": "total_video_view_total_time_paid",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_view_total_time_paid/lifetime"
                  },
                  {
                    "name": "total_video_impressions",
                    "values": [
                      {
                        "value": 1
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_impressions/lifetime"
                  },
                  {
                    "name": "total_video_impressions_unique",
                    "values": [
                      {
                        "value": 1
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_impressions_unique/lifetime"
                  },
                  {
                    "name": "total_video_impressions_paid_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_impressions_paid_unique/lifetime"
                  },
                  {
                    "name": "total_video_impressions_paid",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_impressions_paid/lifetime"
                  },
                  {
                    "name": "total_video_impressions_organic_unique",
                    "values": [
                      {
                        "value": 1
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_impressions_organic_unique/lifetime"
                  },
                  {
                    "name": "total_video_impressions_organic",
                    "values": [
                      {
                        "value": 1
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_impressions_organic/lifetime"
                  },
                  {
                    "name": "total_video_impressions_viral_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_impressions_viral_unique/lifetime"
                  },
                  {
                    "name": "total_video_impressions_viral",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_impressions_viral/lifetime"
                  },
                  {
                    "name": "total_video_impressions_fan_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_impressions_fan_unique/lifetime"
                  },
                  {
                    "name": "total_video_impressions_fan",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_impressions_fan/lifetime"
                  },
                  {
                    "name": "total_video_impressions_fan_paid_unique",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_impressions_fan_paid_unique/lifetime"
                  },
                  {
                    "name": "total_video_impressions_fan_paid",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_impressions_fan_paid/lifetime"
                  },
                  {
                    "name": "total_video_stories_by_action_type",
                    "values": [
                      {
                        "value": {}
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_stories_by_action_type/lifetime"
                  },
                  {
                    "name": "total_video_reactions_by_type_total",
                    "values": [
                      {
                        "value": {}
                      }
                    ],
                    "id": "755568755205096/video_insights/total_video_reactions_by_type_total/lifetime"
                  }
                ]
              }
            }
          ],
          "paging": {
            "cursors": {
              "before": "NzU1NTY4NzU1MjA1MDk2",
              "after": "NzU1NTY4NzU1MjA1MDk2"
            }
          }
        },
        "id": "109726977412856"
      }.to_json
    end
  end
end