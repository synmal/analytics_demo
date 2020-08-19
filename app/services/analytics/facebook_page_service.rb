class Analytics::FacebookPageService
  LIFETIME_INSIGHTS = [
    'post_impressions',
    'post_impressions_organic',
    'post_impressions_organic_unique',
    'post_impressions_paid',
    'post_impressions_paid_unique',
    'post_impressions_unique',
    'post_engaged_users',
    'post_negative_feedback',
    'post_engaged_fan',
    'post_video_avg_time_watched',
    'post_video_view_time',
    'post_video_views',
    'page_video_complete_views_30s',
    'page_video_complete_views_30s_organic',
    'page_video_complete_views_30s_paid',
    'page_video_views_organic'
  ]

  class << self
    def get_posts
      fields = "posts{id,permalink_url,message,attachments{media_type,target},insights.metric(#{LIFETIME_INSIGHTS.join(',')}){name, values}}"
      # response = call(fields)
      # parse_response(response)
      initial_data = parse_response(dummy_data)
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
                    "name": "post_impressions",
                    "values": [
                      {
                        "value": 1
                      }
                    ],
                    "id": "109726977412856_155874559464764/insights/post_impressions/lifetime"
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
                    "name": "post_impressions_unique",
                    "values": [
                      {
                        "value": 1
                      }
                    ],
                    "id": "109726977412856_155874559464764/insights/post_impressions_unique/lifetime"
                  },
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
                    "name": "post_engaged_fan",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_155874559464764/insights/post_engaged_fan/lifetime"
                  },
                  {
                    "name": "post_video_avg_time_watched",
                    "values": [
                      {
                        "value": 2715
                      }
                    ],
                    "id": "109726977412856_155874559464764/insights/post_video_avg_time_watched/lifetime"
                  },
                  {
                    "name": "post_video_view_time",
                    "values": [
                      {
                        "value": 2715
                      }
                    ],
                    "id": "109726977412856_155874559464764/insights/post_video_view_time/lifetime"
                  },
                  {
                    "name": "post_video_views",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_155874559464764/insights/post_video_views/lifetime"
                  },
                  {
                    "name": "post_video_view_time",
                    "values": [
                      {
                        "value": 0,
                        "end_time": "2020-08-15T07:00:00+0000"
                      },
                      {
                        "value": 0,
                        "end_time": "2020-08-16T07:00:00+0000"
                      }
                    ],
                    "id": "109726977412856_155874559464764/insights/post_video_view_time/day"
                  },
                  {
                    "name": "post_video_views",
                    "values": [
                      {
                        "value": 0,
                        "end_time": "2020-08-15T07:00:00+0000"
                      },
                      {
                        "value": 0,
                        "end_time": "2020-08-16T07:00:00+0000"
                      }
                    ],
                    "id": "109726977412856_155874559464764/insights/post_video_views/day"
                  }
                ],
                "paging": {
                  "previous": "https://graph.facebook.com/v7.0/109726977412856_155874559464764/insights?access_token=EAAsjz6AuZBbEBAJH9nt4fswMs9rBe9r7GO9XAKA8Iwz8i5nDxZBWwiqGAkzHdeOTSnzxjhi53aqWdAkgrZBWXWOz76wng3W6Ic52z8brJ5Mz9ZB5hBGZB75CHnDb1sTnXq7Rm8GKRRx48ERBJZCBpaHV2ZB1qflWtXxxujHV8iSZBJUhnE1AUn6RqfnjokbowLsZD&fields=name%2C+values&metric=post_impressions%2Cpost_impressions_organic%2Cpost_impressions_organic_unique%2Cpost_impressions_paid%2Cpost_impressions_paid_unique%2Cpost_impressions_unique%2Cpost_engaged_users%2Cpost_negative_feedback%2Cpost_engaged_fan%2Cpost_video_avg_time_watched%2Cpost_video_view_time%2Cpost_video_views%2Cpage_video_complete_views_30s%2Cpage_video_complete_views_30s_organic%2Cpage_video_complete_views_30s_paid%2Cpage_video_views_organic&since=1597215600&until=1597388400",
                  "next": "https://graph.facebook.com/v7.0/109726977412856_155874559464764/insights?access_token=EAAsjz6AuZBbEBAJH9nt4fswMs9rBe9r7GO9XAKA8Iwz8i5nDxZBWwiqGAkzHdeOTSnzxjhi53aqWdAkgrZBWXWOz76wng3W6Ic52z8brJ5Mz9ZB5hBGZB75CHnDb1sTnXq7Rm8GKRRx48ERBJZCBpaHV2ZB1qflWtXxxujHV8iSZBJUhnE1AUn6RqfnjokbowLsZD&fields=name%2C+values&metric=post_impressions%2Cpost_impressions_organic%2Cpost_impressions_organic_unique%2Cpost_impressions_paid%2Cpost_impressions_paid_unique%2Cpost_impressions_unique%2Cpost_engaged_users%2Cpost_negative_feedback%2Cpost_engaged_fan%2Cpost_video_avg_time_watched%2Cpost_video_view_time%2Cpost_video_views%2Cpage_video_complete_views_30s%2Cpage_video_complete_views_30s_organic%2Cpage_video_complete_views_30s_paid%2Cpage_video_views_organic&since=1597561200&until=1597734000"
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
                    "name": "post_impressions",
                    "values": [
                      {
                        "value": 2
                      }
                    ],
                    "id": "109726977412856_153221506396736/insights/post_impressions/lifetime"
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
                    "name": "post_impressions_unique",
                    "values": [
                      {
                        "value": 1
                      }
                    ],
                    "id": "109726977412856_153221506396736/insights/post_impressions_unique/lifetime"
                  },
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
                    "name": "post_engaged_fan",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153221506396736/insights/post_engaged_fan/lifetime"
                  },
                  {
                    "name": "post_video_avg_time_watched",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153221506396736/insights/post_video_avg_time_watched/lifetime"
                  },
                  {
                    "name": "post_video_view_time",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153221506396736/insights/post_video_view_time/lifetime"
                  },
                  {
                    "name": "post_video_views",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153221506396736/insights/post_video_views/lifetime"
                  },
                  {
                    "name": "post_video_view_time",
                    "values": [
                      {
                        "value": 0,
                        "end_time": "2020-08-15T07:00:00+0000"
                      },
                      {
                        "value": 0,
                        "end_time": "2020-08-16T07:00:00+0000"
                      }
                    ],
                    "id": "109726977412856_153221506396736/insights/post_video_view_time/day"
                  },
                  {
                    "name": "post_video_views",
                    "values": [
                      {
                        "value": 0,
                        "end_time": "2020-08-15T07:00:00+0000"
                      },
                      {
                        "value": 0,
                        "end_time": "2020-08-16T07:00:00+0000"
                      }
                    ],
                    "id": "109726977412856_153221506396736/insights/post_video_views/day"
                  }
                ],
                "paging": {
                  "previous": "https://graph.facebook.com/v7.0/109726977412856_153221506396736/insights?access_token=EAAsjz6AuZBbEBAJH9nt4fswMs9rBe9r7GO9XAKA8Iwz8i5nDxZBWwiqGAkzHdeOTSnzxjhi53aqWdAkgrZBWXWOz76wng3W6Ic52z8brJ5Mz9ZB5hBGZB75CHnDb1sTnXq7Rm8GKRRx48ERBJZCBpaHV2ZB1qflWtXxxujHV8iSZBJUhnE1AUn6RqfnjokbowLsZD&fields=name%2C+values&metric=post_impressions%2Cpost_impressions_organic%2Cpost_impressions_organic_unique%2Cpost_impressions_paid%2Cpost_impressions_paid_unique%2Cpost_impressions_unique%2Cpost_engaged_users%2Cpost_negative_feedback%2Cpost_engaged_fan%2Cpost_video_avg_time_watched%2Cpost_video_view_time%2Cpost_video_views%2Cpage_video_complete_views_30s%2Cpage_video_complete_views_30s_organic%2Cpage_video_complete_views_30s_paid%2Cpage_video_views_organic&since=1597215600&until=1597388400",
                  "next": "https://graph.facebook.com/v7.0/109726977412856_153221506396736/insights?access_token=EAAsjz6AuZBbEBAJH9nt4fswMs9rBe9r7GO9XAKA8Iwz8i5nDxZBWwiqGAkzHdeOTSnzxjhi53aqWdAkgrZBWXWOz76wng3W6Ic52z8brJ5Mz9ZB5hBGZB75CHnDb1sTnXq7Rm8GKRRx48ERBJZCBpaHV2ZB1qflWtXxxujHV8iSZBJUhnE1AUn6RqfnjokbowLsZD&fields=name%2C+values&metric=post_impressions%2Cpost_impressions_organic%2Cpost_impressions_organic_unique%2Cpost_impressions_paid%2Cpost_impressions_paid_unique%2Cpost_impressions_unique%2Cpost_engaged_users%2Cpost_negative_feedback%2Cpost_engaged_fan%2Cpost_video_avg_time_watched%2Cpost_video_view_time%2Cpost_video_views%2Cpage_video_complete_views_30s%2Cpage_video_complete_views_30s_organic%2Cpage_video_complete_views_30s_paid%2Cpage_video_views_organic&since=1597561200&until=1597734000"
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
                    "name": "post_impressions",
                    "values": [
                      {
                        "value": 2
                      }
                    ],
                    "id": "109726977412856_153220469730173/insights/post_impressions/lifetime"
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
                    "name": "post_impressions_unique",
                    "values": [
                      {
                        "value": 1
                      }
                    ],
                    "id": "109726977412856_153220469730173/insights/post_impressions_unique/lifetime"
                  },
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
                    "name": "post_engaged_fan",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153220469730173/insights/post_engaged_fan/lifetime"
                  },
                  {
                    "name": "post_video_avg_time_watched",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153220469730173/insights/post_video_avg_time_watched/lifetime"
                  },
                  {
                    "name": "post_video_view_time",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153220469730173/insights/post_video_view_time/lifetime"
                  },
                  {
                    "name": "post_video_views",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153220469730173/insights/post_video_views/lifetime"
                  },
                  {
                    "name": "post_video_view_time",
                    "values": [
                      {
                        "value": 0,
                        "end_time": "2020-08-15T07:00:00+0000"
                      },
                      {
                        "value": 0,
                        "end_time": "2020-08-16T07:00:00+0000"
                      }
                    ],
                    "id": "109726977412856_153220469730173/insights/post_video_view_time/day"
                  },
                  {
                    "name": "post_video_views",
                    "values": [
                      {
                        "value": 0,
                        "end_time": "2020-08-15T07:00:00+0000"
                      },
                      {
                        "value": 0,
                        "end_time": "2020-08-16T07:00:00+0000"
                      }
                    ],
                    "id": "109726977412856_153220469730173/insights/post_video_views/day"
                  }
                ],
                "paging": {
                  "previous": "https://graph.facebook.com/v7.0/109726977412856_153220469730173/insights?access_token=EAAsjz6AuZBbEBAJH9nt4fswMs9rBe9r7GO9XAKA8Iwz8i5nDxZBWwiqGAkzHdeOTSnzxjhi53aqWdAkgrZBWXWOz76wng3W6Ic52z8brJ5Mz9ZB5hBGZB75CHnDb1sTnXq7Rm8GKRRx48ERBJZCBpaHV2ZB1qflWtXxxujHV8iSZBJUhnE1AUn6RqfnjokbowLsZD&fields=name%2C+values&metric=post_impressions%2Cpost_impressions_organic%2Cpost_impressions_organic_unique%2Cpost_impressions_paid%2Cpost_impressions_paid_unique%2Cpost_impressions_unique%2Cpost_engaged_users%2Cpost_negative_feedback%2Cpost_engaged_fan%2Cpost_video_avg_time_watched%2Cpost_video_view_time%2Cpost_video_views%2Cpage_video_complete_views_30s%2Cpage_video_complete_views_30s_organic%2Cpage_video_complete_views_30s_paid%2Cpage_video_views_organic&since=1597215600&until=1597388400",
                  "next": "https://graph.facebook.com/v7.0/109726977412856_153220469730173/insights?access_token=EAAsjz6AuZBbEBAJH9nt4fswMs9rBe9r7GO9XAKA8Iwz8i5nDxZBWwiqGAkzHdeOTSnzxjhi53aqWdAkgrZBWXWOz76wng3W6Ic52z8brJ5Mz9ZB5hBGZB75CHnDb1sTnXq7Rm8GKRRx48ERBJZCBpaHV2ZB1qflWtXxxujHV8iSZBJUhnE1AUn6RqfnjokbowLsZD&fields=name%2C+values&metric=post_impressions%2Cpost_impressions_organic%2Cpost_impressions_organic_unique%2Cpost_impressions_paid%2Cpost_impressions_paid_unique%2Cpost_impressions_unique%2Cpost_engaged_users%2Cpost_negative_feedback%2Cpost_engaged_fan%2Cpost_video_avg_time_watched%2Cpost_video_view_time%2Cpost_video_views%2Cpage_video_complete_views_30s%2Cpage_video_complete_views_30s_organic%2Cpage_video_complete_views_30s_paid%2Cpage_video_views_organic&since=1597561200&until=1597734000"
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
                    "name": "post_impressions",
                    "values": [
                      {
                        "value": 2
                      }
                    ],
                    "id": "109726977412856_153207216398165/insights/post_impressions/lifetime"
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
                    "name": "post_impressions_unique",
                    "values": [
                      {
                        "value": 1
                      }
                    ],
                    "id": "109726977412856_153207216398165/insights/post_impressions_unique/lifetime"
                  },
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
                    "name": "post_engaged_fan",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153207216398165/insights/post_engaged_fan/lifetime"
                  },
                  {
                    "name": "post_video_avg_time_watched",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153207216398165/insights/post_video_avg_time_watched/lifetime"
                  },
                  {
                    "name": "post_video_view_time",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153207216398165/insights/post_video_view_time/lifetime"
                  },
                  {
                    "name": "post_video_views",
                    "values": [
                      {
                        "value": 0
                      }
                    ],
                    "id": "109726977412856_153207216398165/insights/post_video_views/lifetime"
                  },
                  {
                    "name": "post_video_view_time",
                    "values": [
                      {
                        "value": 0,
                        "end_time": "2020-08-15T07:00:00+0000"
                      },
                      {
                        "value": 0,
                        "end_time": "2020-08-16T07:00:00+0000"
                      }
                    ],
                    "id": "109726977412856_153207216398165/insights/post_video_view_time/day"
                  },
                  {
                    "name": "post_video_views",
                    "values": [
                      {
                        "value": 0,
                        "end_time": "2020-08-15T07:00:00+0000"
                      },
                      {
                        "value": 0,
                        "end_time": "2020-08-16T07:00:00+0000"
                      }
                    ],
                    "id": "109726977412856_153207216398165/insights/post_video_views/day"
                  }
                ],
                "paging": {
                  "previous": "https://graph.facebook.com/v7.0/109726977412856_153207216398165/insights?access_token=EAAsjz6AuZBbEBAJH9nt4fswMs9rBe9r7GO9XAKA8Iwz8i5nDxZBWwiqGAkzHdeOTSnzxjhi53aqWdAkgrZBWXWOz76wng3W6Ic52z8brJ5Mz9ZB5hBGZB75CHnDb1sTnXq7Rm8GKRRx48ERBJZCBpaHV2ZB1qflWtXxxujHV8iSZBJUhnE1AUn6RqfnjokbowLsZD&fields=name%2C+values&metric=post_impressions%2Cpost_impressions_organic%2Cpost_impressions_organic_unique%2Cpost_impressions_paid%2Cpost_impressions_paid_unique%2Cpost_impressions_unique%2Cpost_engaged_users%2Cpost_negative_feedback%2Cpost_engaged_fan%2Cpost_video_avg_time_watched%2Cpost_video_view_time%2Cpost_video_views%2Cpage_video_complete_views_30s%2Cpage_video_complete_views_30s_organic%2Cpage_video_complete_views_30s_paid%2Cpage_video_views_organic&since=1597215600&until=1597388400",
                  "next": "https://graph.facebook.com/v7.0/109726977412856_153207216398165/insights?access_token=EAAsjz6AuZBbEBAJH9nt4fswMs9rBe9r7GO9XAKA8Iwz8i5nDxZBWwiqGAkzHdeOTSnzxjhi53aqWdAkgrZBWXWOz76wng3W6Ic52z8brJ5Mz9ZB5hBGZB75CHnDb1sTnXq7Rm8GKRRx48ERBJZCBpaHV2ZB1qflWtXxxujHV8iSZBJUhnE1AUn6RqfnjokbowLsZD&fields=name%2C+values&metric=post_impressions%2Cpost_impressions_organic%2Cpost_impressions_organic_unique%2Cpost_impressions_paid%2Cpost_impressions_paid_unique%2Cpost_impressions_unique%2Cpost_engaged_users%2Cpost_negative_feedback%2Cpost_engaged_fan%2Cpost_video_avg_time_watched%2Cpost_video_view_time%2Cpost_video_views%2Cpage_video_complete_views_30s%2Cpage_video_complete_views_30s_organic%2Cpage_video_complete_views_30s_paid%2Cpage_video_views_organic&since=1597561200&until=1597734000"
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
        "id": "109726977412856"
      }.to_json
    end
  end
end