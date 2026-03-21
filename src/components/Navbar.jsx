import { Link } from "react-router-dom";

function Navbar() {
    return (
        <nav style={styles.nav}>
         <h2>ShopSite</h2>
         <div>
            <Link style={styles.link} to="/">Home</Link>
            <Link style={styles.link} to="/services">Services</Link>
            <Link style={styles.link} to="/pricing">Pricing</Link>
            <Link style={styles.link} to="/contact">Contact</Link>
          </div>
        </nav>
    );
}

const styles = {
    nav: {
        display: "flex",
        justifyContent: "space-between",
        padding: "15px 40px",
        background: "#111",
        color: "#fff",
    },
    link: {
        marginLeft: "20px",
        color: "#fff",
        TextDecoration: "none",
    },
};

export default Navbar;