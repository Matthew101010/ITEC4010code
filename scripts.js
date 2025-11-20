function searchPostings() {
    const term = document.getElementById("searchInput").value;

    const results = `
        <div class="card">
            <h3>Community Clean-Up</h3>
            <p>Location: Downtown</p>
            <a href="posting.html" class="btn">View</a>
        </div>

        <div class="card">
            <h3>Food Bank Helper</h3>
            <p>Location: City Center</p>
            <a href="posting.html" class="btn">View</a>
        </div>
    `;

    document.getElementById("postList").innerHTML = results;
}
