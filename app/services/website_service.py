class WebsiteService:
    def __init__(self):
        self.websites_db = []
    
    def create_website(self, data):
        website_id = f"site_{len(self.websites_db) + 1}"
        website = {
            "id": website_id,
            "name": data["name"],
            "template": data["template"],
            "description": data.get("description", ""),
            "status": "generated",
            "created_at": "2024-01-01T00:00:00",
            "preview_url": f"/preview/{website_id}/index.html"
        }
        self.websites_db.append(website)
        return website
    
    def list_websites(self):
        return self.websites_db
    
    def get_website(self, website_id):
        for site in self.websites_db:
            if site["id"] == website_id:
                return site
        return None
    
    def get_site_html(self, site_id):
        return f"<h1>{site_id} Preview</h1><p>AI Generated Site</p>"
    
    def get_page_html(self, site_id, page):
        return f"<h1>{page.title()} - {site_id}</h1>"
    
    def save_contact_form(self, site_id, data):
        print(f"Contact: {data}")
        return True
    
    def delete_website(self, website_id):
        self.websites_db = [w for w in self.websites_db if w["id"] != website_id]
    
    def get_all_public_websites(self):
        return [{"id": w["id"], "name": w["name"]} for w in self.websites_db]