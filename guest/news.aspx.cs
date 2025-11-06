using System;
using System.Collections.Generic;
using System.Net;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Xml;
using static System.Net.WebRequestMethods;

namespace WebApplication
{
    [Serializable]
    public class NewsItem
    {
        private string title;
        private string link;
        private string pubDate;

        public string Title
        {
            get { return title; }
            set { title = value; }
        }

        public string Link
        {
            get { return link; }
            set { link = value; }
        }

        public string PubDate
        {
            get { return pubDate; }
            set { pubDate = value; }
        }
    }

    public partial class news : System.Web.UI.Page
    {
        //protected HtmlGenericControl ulNews;
        //protected Label lblNewsError;
        //protected LinkButton btnPrevious;
        //protected LinkButton btnNext;
        //protected Literal litPageInfo;
        //protected HtmlGenericControl paginationControls;

        private const int PageSize = 5;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ViewState["CurrentPage"] = 1;
                LoadAllNews();
                DisplayCurrentPage();
            }
        }

        private void LoadAllNews()
        {
            string rssUrl = "https://www.sciencedaily.com/rss/top/health.xml";
         
            List<NewsItem> allNewsItems = new List<NewsItem>();

            try
            {
                WebClient client = new WebClient();
                try
                {
                    client.Headers.Add("User-Agent", "Mozilla/5.0");

                    string xmlContent = client.DownloadString(rssUrl);

                    XmlDocument doc = new XmlDocument();
                    doc.LoadXml(xmlContent);

                    XmlNodeList items = doc.GetElementsByTagName("item");

                    if (items == null || items.Count == 0)
                    {
                        lblNewsError.Text = "No news items available at this time.";
                        lblNewsError.Visible = true;
                        return;
                    }

                    foreach (XmlNode item in items)
                    {
                        XmlNode titleNode = item["title"];
                        XmlNode linkNode = item["link"];
                        XmlNode pubDateNode = item["pubDate"];

                        NewsItem newsItem = new NewsItem();
                        newsItem.Title = (titleNode != null) ? titleNode.InnerText : "No Title";
                        newsItem.Link = (linkNode != null) ? linkNode.InnerText : "#";
                        newsItem.PubDate = (pubDateNode != null) ? pubDateNode.InnerText : "";

                        allNewsItems.Add(newsItem);
                    }

                    ViewState["AllNews"] = allNewsItems;
                }
                finally
                {
                    client.Dispose();
                }
            }
            catch (WebException)
            {
                lblNewsError.Text = "Unable to connect to news feed. Please check your internet connection.";
                lblNewsError.Visible = true;
            }
            catch (Exception)
            {
                lblNewsError.Text = "Unable to fetch latest news at this time. Please try again later.";
                lblNewsError.Visible = true;
            }
        }

        private void DisplayCurrentPage()
        {
            ulNews.Controls.Clear();

            List<NewsItem> allNewsItems = new List<NewsItem>();
            if (ViewState["AllNews"] != null)
            {
                allNewsItems = (List<NewsItem>)ViewState["AllNews"];
            }

            if (allNewsItems.Count == 0)
            {
                lblNewsError.Text = "No news items found.";
                lblNewsError.Visible = true;
                paginationControls.Visible = false;
                return;
            }

            int currentPage = (int)ViewState["CurrentPage"];
            int totalPages = (int)Math.Ceiling((double)allNewsItems.Count / PageSize);

            int startIndex = (currentPage - 1) * PageSize;
            int endIndex = Math.Min(startIndex + PageSize, allNewsItems.Count);

            for (int i = startIndex; i < endIndex; i++)
            {
                NewsItem newsItem = allNewsItems[i];

                HtmlGenericControl li = new HtmlGenericControl("li");
                li.Attributes.Add("class", "news-card");

                HtmlGenericControl iconDiv = new HtmlGenericControl("div");
                iconDiv.Attributes.Add("class", "news-icon");
                iconDiv.InnerText = "📰";
                li.Controls.Add(iconDiv);

                HtmlAnchor a = new HtmlAnchor();
                a.HRef = newsItem.Link;
                a.Target = "_blank";
                a.InnerText = newsItem.Title;
                a.Attributes.Add("class", "news-title");
                li.Controls.Add(a);

                if (!string.IsNullOrEmpty(newsItem.PubDate))
                {
                    HtmlGenericControl span = new HtmlGenericControl("span");
                    span.Attributes.Add("class", "news-date");

                    DateTime dt;
                    if (DateTime.TryParse(newsItem.PubDate, out dt))
                        span.InnerText = dt.ToString("MMM dd, yyyy");
                    else
                        span.InnerText = newsItem.PubDate;

                    li.Controls.Add(span);
                }

                ulNews.Controls.Add(li);
            }

            litPageInfo.Text = "Page " + currentPage.ToString() + " of " + totalPages.ToString();

            // Show/hide and enable/disable pagination
            paginationControls.Visible = true;

            if (currentPage <= 1)
            {
                btnPrevious.CssClass = "pagination-btn disabled";
                btnPrevious.Enabled = false;
            }
            else
            {
                btnPrevious.CssClass = "pagination-btn";
                btnPrevious.Enabled = true;
            }

            if (currentPage >= totalPages)
            {
                btnNext.CssClass = "pagination-btn disabled";
                btnNext.Enabled = false;
            }
            else
            {
                btnNext.CssClass = "pagination-btn";
                btnNext.Enabled = true;
            }
        }

        protected void btnPrevious_Click(object sender, EventArgs e)
        {
            int currentPage = (int)ViewState["CurrentPage"];
            if (currentPage > 1)
            {
                ViewState["CurrentPage"] = currentPage - 1;
                DisplayCurrentPage();
            }
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            List<NewsItem> allNewsItems = new List<NewsItem>();
            if (ViewState["AllNews"] != null)
            {
                allNewsItems = (List<NewsItem>)ViewState["AllNews"];
                int totalPages = (int)Math.Ceiling((double)allNewsItems.Count / PageSize);
                int currentPage = (int)ViewState["CurrentPage"];

                if (currentPage < totalPages)
                {
                    ViewState["CurrentPage"] = currentPage + 1;
                    DisplayCurrentPage();
                }
            }
        }
    }
}