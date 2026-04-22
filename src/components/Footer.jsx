function Footer() {
    return (
        <footer style={styles.footer}>
           <p>© 2026 ShopSite Platform | Built on AWS</p>
        </footer>
    );
}

const styles = {
    footer: {
        textAlign: "center",
        padding: "20px",
        background: "#111",
        color: "#fff",
        marginTop: "40px",
    },
};

export default Footer;