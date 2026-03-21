function Services() {
    return (
        <div style={styles.container}>
            <h1>Our Services</h1>
            <ul>
                <li>Website Development</li>
                <li>Cloud Deployment (S3 + CloudFront)</li>
                <li>CI/CD Automation</li>
                <li>Performance Optimization</li>
            </ul>
        </div>
    );
}

const styles = {
    container: {
        padding: "60px",
    },
};

export default Services;